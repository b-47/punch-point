#!/usr/bin/env python3
"""Check that every test rig part prints cleanly, without supports.

    python3 tools/print_check.py

Each STL in concepts/test-rig/print/ is sliced layer by layer in print orientation.
A part fails on material over thin air (only overhangs of 1.2 mm or less, slopes no
flatter than about 51 degrees, and bridges that land on material at both ends pass),
on slivers narrower than one 0.4 mm line, on loose specks, and on how it stands on the
bed (centre of mass over the first layer, nothing tall on a narrow base).

It also reads the plate's G-code and fails unless it has the walls the rig needs and a
brim that actually prints.

The layer checks are copied from pc-case/tools/build.py, where they caught real print faults.
"""
import concurrent.futures as cf
import re
import sys
from pathlib import Path

import numpy as np
import trimesh

ROOT = Path(__file__).resolve().parent.parent
PRINT = ROOT / "concepts" / "test-rig" / "print"

LAYER = 0.2
OVERHANG_OK = 1.2      # mm a layer may reach past the one below
SLOPE_SPAN = 5         # layers: no more than OVERHANG_OK + ~51 deg past the layer this far down
BRIDGE_MAX = 12.0      # mm between anchors: PrusaSlicer's stability check flags PLA bridges past 16
MIN_FEATURE = 0.4      # mm: anything narrower in a layer is thinner than one nozzle line
SLENDER_MAX = 4.0      # height / narrowest width of the first layer
ISLAND_MIN = 6.0       # mm2: a first-layer island smaller than this gets knocked off
FUSE_W = 0.3           # mm: an opening narrower than this fuses shut when printed
THIN_W = 1.0           # mm: material narrower than this prints as 1 or 2 lines: fine for a lip, weak for a stop


def _layers(mesh):
    import shapely
    from shapely import affinity
    zs = np.arange(LAYER / 2, mesh.bounds[1][2], LAYER)
    out = []
    for z, sec in zip(zs, mesh.section_multiplane([0, 0, 0], [0, 0, 1], zs)):
        if sec is None:
            out.append((z, shapely.Polygon()))
            continue
        t = sec.metadata["to_3D"]
        polys = [affinity.affine_transform(p, [t[0, 0], t[0, 1], t[1, 0], t[1, 1], t[0, 3], t[1, 3]])
                 for p in sec.polygons_full]
        out.append((z, shapely.union_all(polys) if polys else shapely.Polygon()))
    return out


def printability(mesh):
    """Unsupported regions that are neither short overhangs nor anchored bridges, and slivers."""
    import shapely
    from shapely.geometry import LineString, Point
    bad = []
    layers = _layers(mesh)
    for z, here in layers:
        if here.is_empty:
            continue
        opened = here.buffer(-MIN_FEATURE / 2, join_style=2).buffer(MIN_FEATURE / 2 + 0.02, join_style=2)
        thin = here.difference(opened)
        for g in getattr(thin, "geoms", [thin]):
            if g.area >= 0.3:
                bad.append(dict(z=round(float(z), 1), area=round(g.area, 1), bbox=[round(v, 1) for v in g.bounds],
                                reach=f"sliver < {MIN_FEATURE}"))
    dirs = [(np.cos(a), np.sin(a)) for a in np.radians(np.arange(0, 180, 15))]
    bridged = {}
    for k in range(1, len(layers)):
        (z0, below), (z, here) = layers[k - 1], layers[k]
        if here.is_empty:
            continue
        kd = max(0, k - SLOPE_SPAN)
        creep = layers[kd][1].buffer((k - kd) * LAYER * 1.25 + OVERHANG_OK)
        for j in range(kd + 1, k):
            if j in bridged:
                creep = creep.union(bridged[j].buffer((k - j) * LAYER * 1.25 + OVERHANG_OK))
        loose = here.difference(below.buffer(LAYER + 0.05))
        for c in getattr(loose, "geoms", [loose]):
            if c.area < 0.5:
                continue
            near = below.intersection(c.envelope.buffer(BRIDGE_MAX + 1))
            rim = shapely.line_merge(c.exterior.intersection(here.boundary.buffer(0.05)))
            for seg in getattr(rim, "geoms", [rim]):
                if seg.geom_type == "LineString" and 0 < seg.length <= BRIDGE_MAX and \
                        all(below.distance(Point(q)) < 0.6 for q in (seg.coords[0], seg.coords[-1])) and \
                        max(below.distance(Point(q)) for q in seg.segmentize(0.5).coords) > OVERHANG_OK:
                    near = near.union(seg.buffer(0.1))
            inner = c.buffer(-0.15)
            if inner.is_empty:
                inner = c
            pts = [Point(p) for g in getattr(inner, "geoms", [inner]) for p in np.asarray(g.exterior.segmentize(0.8).coords)]
            x0, y0, x1, y1 = c.bounds
            for gx in np.arange(x0, x1, 1.0):
                for gy in np.arange(y0, y1, 1.0):
                    pt = Point(gx, gy)
                    if inner.contains(pt):
                        pts.append(pt)
            far = [p for p in pts if near.distance(p) > OVERHANG_OK or not creep.contains(p)]
            if not far:
                continue

            def spans(p, d):
                ends = []
                for sgn in (1, -1):
                    ray = LineString([(p.x, p.y), (p.x + sgn * d[0] * BRIDGE_MAX, p.y + sgn * d[1] * BRIDGE_MAX)])
                    inside = ray.intersection(here)
                    run = min(getattr(inside, "geoms", [inside]), key=lambda g: g.distance(p), default=None)
                    if run is None or run.is_empty or run.distance(p) > 0.05:
                        return None
                    hit = run.intersection(near)
                    if hit.is_empty:
                        return None
                    ends.append(p.distance(hit))
                return sum(ends)
            ok = False
            for d in dirs:
                lens = [spans(p, d) for p in far]
                if all(v is not None and v <= BRIDGE_MAX for v in lens):
                    ok = True
                    bridged[k] = c if k not in bridged else bridged[k].union(c)
                    break
            if not ok:
                worst = max(near.distance(p) for p in far)
                bad.append(dict(z=round(float(z), 1), area=round(c.area, 1),
                                bbox=[round(v, 1) for v in c.bounds], reach=round(worst, 1)))
    return bad


def bed_stance(mesh):
    """Centre of mass over the first layer, nothing tall on a narrow base, no tiny first-layer islands."""
    import shapely
    from shapely import affinity
    from shapely.geometry import Point
    bad, warn = [], []
    for b in mesh.split(only_watertight=False):
        if abs(b.volume) < 50:
            continue
        sec = b.section_multiplane([0, 0, 0], [0, 0, 1], [LAYER / 2])[0]
        where = f"body at {np.round(b.bounds[0][:2], 1).tolist()}"
        if sec is None:
            bad.append(f"{where} doesn't touch the bed")
            continue
        t = sec.metadata["to_3D"]
        fl = shapely.union_all([affinity.affine_transform(q, [t[0, 0], t[0, 1], t[1, 0], t[1, 1], t[0, 3], t[1, 3]])
                                for q in sec.polygons_full])
        hull = fl.convex_hull
        if not hull.buffer(-1).contains(Point(b.center_mass[:2])):
            bad.append(f"{where}: centre of mass isn't over the first layer (wrong face down?)")
        xs, ys = hull.minimum_rotated_rectangle.exterior.coords.xy
        base = min(np.hypot(xs[i + 1] - xs[i], ys[i + 1] - ys[i]) for i in range(4))
        h = b.bounds[1][2]
        if h / max(base, 0.1) > SLENDER_MAX:
            bad.append(f"{where}: {h:.0f} mm tall on a {base:.1f} mm base")
        tiny = [g.area for g in getattr(fl, "geoms", [fl]) if g.area < ISLAND_MIN]
        if tiny:
            warn.append(f"{where}: {len(tiny)} first-layer island(s) under {ISLAND_MIN} mm2")
    return bad, warn


def soft_checks(mesh):
    """Places to judge by eye: openings that would fuse shut, and material under THIN_W wide."""
    fused, thin = [], []
    for z, here in _layers(mesh):
        if here.is_empty:
            continue
        g = here.buffer(FUSE_W / 2, join_style=2).buffer(-FUSE_W / 2, join_style=2).difference(here.buffer(0.01))
        fused += [(round(float(z), 1), round(q.area, 1), [round(v, 1) for v in q.bounds])
                  for q in getattr(g, "geoms", [g]) if q.area >= 0.3]
        t = here.difference(here.buffer(-THIN_W / 2, join_style=2).buffer(THIN_W / 2 + 0.02, join_style=2))
        thin += [(round(float(z), 1), round(q.area, 1), [round(v, 1) for v in q.bounds])
                 for q in getattr(t, "geoms", [t]) if q.area > 1.0]
    return fused, thin


def summarize(hits):
    """Group soft-check hits by place: z range and the largest region."""
    groups = {}
    for z, a, bb in hits:
        key = tuple(round(v) for v in bb)
        g = groups.setdefault(key, [z, z, a])
        g[0], g[1], g[2] = min(g[0], z), max(g[1], z), max(g[2], a)
    return [f"z {z0}-{z1}, up to {a} mm2, around x {k[0]} to {k[2]}, y {k[1]} to {k[3]}" for k, (z0, z1, a) in groups.items()]


def check(path):
    m = trimesh.load(path)
    m.apply_translation([0, 0, -m.bounds[0][2]])      # print orientation, sitting on the bed
    specks = [round(abs(b.volume), 2) for b in m.split(only_watertight=False) if abs(b.volume) < 10]
    stance_bad, stance_warn = bed_stance(m)
    fused, thin = soft_checks(m)
    notes = stance_warn + [f"would fuse shut: {x}" for x in summarize(fused)] + \
        [f"under {THIN_W} mm wide: {x}" for x in summarize(thin)]
    return dict(name=Path(path).stem, watertight=bool(m.is_watertight), specks=specks,
                stance=stance_bad, notes=notes, print=printability(m))


# What the plate's G-code must say: the walls, and a brim that is really there.
GCODE_WANT = {"perimeters": "3", "top_solid_layers": "4", "bottom_solid_layers": "4",
              "fill_density": "15%", "fill_pattern": "gyroid", "brim_width": "5"}


def gcode_audit(path):
    """Settings the plate's G-code was really sliced with. A brim width alone prints nothing:
    the Core One presets have brim_type = no_brim, so the brim lines themselves are counted."""
    if not path.exists():
        return [f"{path.name} is missing: slice the plate"]
    text = path.read_text(errors="replace")
    conf = dict(re.findall(r"^; (\w+) = (.*)$", text, re.M))
    bad = [f"{k} is {conf.get(k, 'missing')}, should be {v}" for k, v in GCODE_WANT.items() if conf.get(k) != v]
    if conf.get("brim_type", "no_brim") == "no_brim" or ";TYPE:Skirt/Brim" not in text:
        bad.append(f"no brim prints (brim_type = {conf.get('brim_type', 'missing')})")
    if re.search(r"^;TYPE:.*[Ss]upport", text, re.M):
        bad.append("the plate prints support material")
    return bad


def main():
    stls = sorted(PRINT.glob("*.stl"))
    ok = True
    with cf.ProcessPoolExecutor() as ex:
        for r in ex.map(check, stls):
            fails = []
            if not r["watertight"]:
                fails.append("not watertight")
            if r["specks"]:
                fails.append(f"loose specks {r['specks']} mm3")
            fails += r["stance"]
            fails += [f"z={b['z']:5.1f}  {b['area']:6.1f} mm2 reaching {b['reach']} mm past support, bbox {b['bbox']}"
                      for b in r["print"]]
            ok &= not fails
            print(f"{r['name']}: {'ok' if not fails else 'FAIL'}")
            for f in fails:
                print(f"  {f}")
            for n in r["notes"]:
                print(f"  note: {n}")
    # one plate per printer: rig_plate (Core One) and rig_plate_mk4
    for plate in sorted(PRINT.glob("rig_plate*.gcode")) or [PRINT / "rig_plate.gcode"]:
        g = gcode_audit(plate)
        ok &= not g
        print(f"{plate.name}: {'ok' if not g else 'FAIL'}")
        for f in g:
            print(f"  {f}")
    print("PRINT CHECK", "PASSED" if ok else "FAILED")
    return ok


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
