"""Rebuild concepts/test-rig/viewer/parts.js from the test rig model.

    python3 tools/build_rig_parts.py

Needs OpenSCAD. Exports each part as a binary STL in assembly coordinates
(27 mm solenoid, plunger at rest) and packs them base64-encoded, so the viewer
also works when opened straight from a folder. Run it after changing the model.
"""
import base64, json, re, shutil, subprocess, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RIG = ROOT / "concepts" / "test-rig"
MODEL = sorted((RIG / "cad").glob("punch_rig_*.scad"))[-1]
PARTS = ["frame", "table", "arm", "sol_frame", "sol_coil", "plunger", "spring", "back_screws",
         "standoff", "nut", "stylus", "die_screw", "die_nuts"]


# the rig as built since version 018: the coupler table, with its 8.3 mm hex tube
COUPLER_TABLE = ["-D", "HEX_AF=8.3", "-D", "NUT_BORE=9.8", "-D", "BOSS_D=12.6"]


def openscad():
    # The nightly build's Manifold backend is much faster; 2021.01 also works.
    if shutil.which("openscad-nightly"):
        return ["openscad-nightly", "--backend=manifold"]
    if shutil.which("openscad"):
        return ["openscad"]
    raise SystemExit("OpenSCAD not found")


def main():
    cmd = openscad()
    meshes, geom = {}, {}
    with tempfile.TemporaryDirectory() as tmp:
        for name in PARTS:
            out = Path(tmp) / f"{name}.stl"
            run = subprocess.run([*cmd, "--export-format=binstl", "-o", str(out), "-D", f'PART="{name}"', *COUPLER_TABLE, str(MODEL)],
                                 check=True, capture_output=True, text=True)
            meshes[name] = base64.b64encode(out.read_bytes()).decode()
            ledges = re.search(r"ledges (-?[\d.]+)", run.stderr)
            if ledges:
                geom["solBot"] = float(ledges.group(1))   # the bottom plate sits on the ledges
    geom["springLen"] = 11   # bottom plate to the plunger's washer at rest, from the seller's drawing
    header = (f"// Part meshes for index.html: binary STLs exported from {MODEL.name} (27 mm solenoid)\n"
              "// in assembly coordinates by tools/build_rig_parts.py, base64-encoded so the page works from a folder.\n")
    (RIG / "viewer" / "parts.js").write_text(
        header + "window.RIG_GEOM = " + json.dumps(geom) + ";\n"
        + "window.RIG_PARTS = " + json.dumps(meshes, sort_keys=True) + ";\n")
    print(f"wrote parts.js from {MODEL.name}: {', '.join(PARTS)}; {geom}")


if __name__ == "__main__":
    main()
