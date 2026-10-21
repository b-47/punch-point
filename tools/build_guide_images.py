"""Render the build guide's step pictures from the latest test rig model into
concepts/test-rig/media/build/. The part being added in each step is orange.
Run after any change to the model: python3 tools/build_guide_images.py"""
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parent.parent
RIG = ROOT / "concepts" / "test-rig"
MODEL = sorted((RIG / "cad").glob("punch_rig_*.scad"))[-1]
OUT = RIG / "media" / "build"

# Scenes: (file name, camera rotation x/y/z, OpenSCAD body). New parts are DarkOrange.
SOL = 'color("DimGray") sol_frame(); color("Chocolate") sol_coil();'
STEPS = {
    "1-pin": ((60, 0, 20), 'color("DarkOrange") rotate([0, 90, 0]) translate([0, 0, -PIN_TIP]) die_screw();'),
    "2-die-parts": ((75, 0, 30), SOL + 'color("Silver") plunger(REST_LIFT); color("Silver") spring(REST_LIFT);'
                    'color("DarkOrange") translate([0, 0, 6]) standoff(0); color("DarkOrange") translate([0, 0, 14]) nut(REST_LIFT);'
                    'color("DarkOrange") translate([0, 0, 24]) stylus(REST_LIFT);'),
    "4-table-nuts": ((50, 0, 25), 'color("SteelBlue") intersection() { frame(); translate([-60, -60, DECK_BOT - 14]) cube([120, 120, 40]); }'
                     'color("DarkOrange") for (p = TABLE_SCREWS) translate([p[0] + (p[1] < SLOT_BACK ? -sign(p[0])*6 : 0), p[1] + (p[1] < SLOT_BACK ? 0 : 9), TNUT_CEIL - NUT_T]) '
                     'rotate([0, 0, table_nut_dir(p)]) hexnut();'),
    "5-slide-in": ((60, 0, 25), 'color("SteelBlue") frame(); translate([0, -30, 0]) { color("DarkOrange") sol_frame(); color("Chocolate") sol_coil();'
                   'color("Silver") plunger(REST_LIFT); color("Silver") spring(REST_LIFT); color("Silver") standoff(0); color("Silver") nut(REST_LIFT); color("Silver") stylus(REST_LIFT); }'),
    "6-back-screws": ((65, 0, 205), 'color("SteelBlue") frame();' + SOL + 'color("Silver") plunger(REST_LIFT); color("DarkOrange") back_screws();'),
    "7-table": ((60, 0, 25), 'color("SteelBlue") frame();' + SOL + 'color("Silver") plunger(REST_LIFT); color("Silver") standoff(0); color("Silver") nut(REST_LIFT); color("Silver") stylus(REST_LIFT);'
               'color("DarkOrange") translate([0, 0, 25]) { table(); table_screws(); }'),
    "8-arm": ((60, 0, 25), 'color("SteelBlue") frame(); color("LightSteelBlue") table(); color("DimGray") table_screws();'
             'color("DarkOrange") translate([0, 0, 22]) { arm(); die_screw(); die_nuts(); }'
             'for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 + ARM_T + 30]) {'
             ' color("Gold") difference() { cylinder(d = WASHER[0], h = WASHER[2]); translate([0, 0, -1]) cylinder(d = WASHER[1], h = 3); }'
             ' color("DarkOrange") { translate([0, 0, WASHER[2] + 4]) cylinder(d = HEAD_D, h = HEAD_H); translate([0, 0, WASHER[2] + 4 - ARM_SCREW_L]) cylinder(d = 3, h = ARM_SCREW_L); } }'),
    "9-finished": ((60, 0, 25), 'assembly();'),
}


def trim(path):
    im = Image.open(path).convert("RGB")
    bg = Image.new("RGB", im.size, im.getpixel((0, 0)))
    box = ImageChops.difference(im, bg).getbbox()
    if box:
        pad = 24
        im = im.crop((max(0, box[0] - pad), max(0, box[1] - pad), min(im.width, box[2] + pad), min(im.height, box[3] + pad)))
    im.save(path)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob("*.png"):
        old.unlink()
    with tempfile.TemporaryDirectory() as tmp:
        for name, ((rx, ry, rz), body) in STEPS.items():
            scad = Path(tmp) / f"{name}.scad"
            scad.write_text(f'include <{MODEL}>\nPART = "none";\n$fn = 48;\n{body}\n')
            png = OUT / f"{name}.png"
            subprocess.run(["openscad-nightly", "--backend=manifold", "--render", "--imgsize=1200,1000", "--viewall", "--autocenter",
                            f"--camera=0,0,0,{rx},{ry},{rz},0", "--colorscheme=Tomorrow", "-o", str(png), str(scad)],
                           check=True, capture_output=True)
            trim(png)
            print("wrote", png.relative_to(ROOT))


if __name__ == "__main__":
    main()
