// Punch Point braille punch test rig v3
//
// One JF-0826B-class solenoid, one steel stylus, one metal die.
// Stylus and die:
//   stylus = M3 x 16 dog-point set screw, tip filed round, locked in an
//            M3 x 18 hex standoff that rides in a close-fit printed hex bore
//   die    = hex socket of an M3 x 25 set screw (socket end down), threaded
//            into the arm; an acorn nut glued on top sets the dot height
// The solenoid sits below the paper and pushes up, so dots come out facing up
// and gravity resets the plunger. Strike loads close inside one C-frame.
//
// Coordinates (mm): punch axis x 0, y 0. z 0 = top of the paper table.
// A paper strip slides along y with its edge on the fence at x = FENCE_X.
//
// Printed parts (PETG):  frame, table (hex fit variants), arm (M3 or M4 die),
// fence shims. PART selects what is rendered; the default is the assembly.

PART = "assembly";  // assembly | section | frame | table | arm | shims
                    // frame_print | table_print | arm_print   (print orientation)
                    // sol_frame | sol_coil | plunger | standoff | nut | stylus
                    // die_screw | die_nuts | paper
STROKE_POS = 0;     // 0 = rest, 1 = end of stroke (assembly / section only)
$fn = 48;

// ---------- solenoid: measure yours and correct these before printing ----------
SOL_LEN      = 27;         // frame length along the plunger axis
SOL_W        = 22;         // frame width across the M3 face (x)
SOL_D        = 25;         // frame depth away from the M3 face (y)
AXIS_TO_FACE = 12.5;       // plunger axis to the M3 face
SOL_HOLE_X   = 6;          // M3 holes at x = +/-6; all four positions are drilled
SOL_HOLE_Z   = [6.5, 21];  // measured from the push-rod end of the frame
STROKE       = 10;
TAIL         = 20;         // plunger and spring below the frame at rest

// ---------- stylus stack ----------
SO_AF      = 5.5;   // standoff across flats
SO_LEN     = 18;
NUT_AF     = 5.5;
NUT_T      = 2.4;
STYLUS_OUT = 6;     // tip above the standoff top, lock nut included
DOG_D      = 2.0;   // ISO 4028 M3 dog point
DOG_L      = 1.5;

// ---------- paper and die ----------
PAPER   = 0.25;     // 65 lb cover is about 0.23 mm; measure each stock
GAP     = 1.0;      // die face (set-screw end) above the table
DOT_H   = 0.5;
TIP_TOP = GAP - PAPER + DOT_H;  // stylus tip at the end of the stroke
DIE_OUT = 0.6;      // set screw below the nose face
DIE_LEN = 25;
DIE_TAP = 2.5;      // tap drill: 2.5 for an M3 set screw, 3.3 for M4
SOCKET_AF = 1.5;    // M3 set-screw socket (M4 is 2.0)

// ---------- printed geometry ----------
HEX_AF      = 5.8;  // guide bore; 5.7 to 6.0 depending on fit
NUT_BORE    = 6.9;  // round bore above the hex, where the lock nut travels
STYLUS_HOLE = 3.4;
SKIN        = 1.6;  // table skin the stylus pokes through; also strips the paper
TABLE_T     = 4;
DECK_T      = 4;
WALL        = 4;
SPINE_T     = 6;
SIDE_CLR    = 0.5;
BOSS_D      = 11;
FENCE_X     = 20;   // fence to punch axis
TOWER_X2    = 32;
ARM_Z0      = 5;
ARM_T       = 10;
ARM_W       = 20;
NOSE_D      = 8;
BASE_T      = 5;

// ---------- derived ----------
SO_TOP_FULL = TIP_TOP - STYLUS_OUT;
SO_TOP_REST = SO_TOP_FULL - STROKE;
SOL_TOP     = SO_TOP_REST - SO_LEN;   // the standoff rests on the frame, like the acorn nut did
SOL_BOT     = SOL_TOP - SOL_LEN;
BOSS_BOT    = SOL_TOP + 2;
DECK_TOP    = -TABLE_T;
DECK_BOT    = DECK_TOP - DECK_T;
BASE_TOP    = SOL_BOT - TAIL - 4;
NOSE_Z      = GAP + DIE_OUT;
FACE_Y      = AXIS_TO_FACE;
FRONT_Y     = FACE_Y - SOL_D;
SPINE_Y2    = FACE_Y + SPINE_T;
SIDE_IN     = SOL_W/2 + SIDE_CLR;
SIDE_OUT    = SIDE_IN + WALL;
WING        = TOWER_X2 - SIDE_OUT;

TABLE_X0 = -46;
TABLE_Y  = 35;
TABLE_SCREWS = [[-10.5, -9], [-10.5, 9], [10.5, -9], [10.5, 9]];
ARM_SCREWS   = [[26, -6], [26, 6]];

function hexd(af) = af / cos(30);   // circumscribed diameter for a $fn = 6 cylinder

// Extrude a (y, z) polygon along +x, starting at x0.
module yz_extrude(pts, x0, len) {
    multmatrix([[0, 0, 1, x0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = len) polygon(pts);
}

// ================================================================ frame
module frame() {
    difference() {
        union() {
            // base
            translate([-32, FRONT_Y - 12, BASE_TOP - BASE_T])
                cube([TOWER_X2 + 38, SPINE_Y2 - FRONT_Y + 12, BASE_T]);
            // side walls locate the solenoid in x
            for (x0 = [-SIDE_OUT, SIDE_IN])
                translate([x0, FRONT_Y, BASE_TOP]) cube([WALL, FACE_Y - FRONT_Y, DECK_BOT - BASE_TOP]);
            // spine: the solenoid's M3 face screws to its front
            translate([-SIDE_OUT, FACE_Y, BASE_TOP]) cube([2*SIDE_OUT, SPINE_T, DECK_TOP - BASE_TOP]);
            // deck carries the table; it bridges the side walls when printed upright
            translate([-SIDE_OUT, FRONT_Y, DECK_BOT]) cube([SIDE_OUT + TOWER_X2, SPINE_Y2 - FRONT_Y, DECK_T]);
            // 45 degree wedge under the +x wing, so it prints without support
            hull() {
                translate([SIDE_OUT - 0.01, FRONT_Y, DECK_BOT - WING]) cube([0.01, SPINE_Y2 - FRONT_Y, WING]);
                translate([SIDE_OUT, FRONT_Y, DECK_BOT - 0.01]) cube([WING, SPINE_Y2 - FRONT_Y, 0.01]);
            }
            // tower: its inner face is the paper fence, its top carries the arm
            translate([FENCE_X, FRONT_Y, DECK_TOP]) cube([TOWER_X2 - FENCE_X, SPINE_Y2 - FRONT_Y, ARM_Z0 - DECK_TOP]);
        }
        // slot for the guide boss, open to the front: the solenoid slides in with its stylus
        // already fitted, and the boss has +/-1.5 mm to line up with the plunger
        hull() {
            translate([0, 0, DECK_BOT - 1]) cylinder(d = 14, h = DECK_T + 2);
            translate([-7, FRONT_Y - 1, DECK_BOT - 1]) cube([14, 1, DECK_T + 2]);
        }
        // table screws, self-tapping
        for (p = TABLE_SCREWS) translate([p[0], p[1], DECK_BOT - 1]) cylinder(d = 2.8, h = DECK_T + 2);
        // arm screws, self-tapping
        for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 - 12]) cylinder(d = 2.8, h = 13);
        // solenoid screws: M3 x 6 from the back leaves 2 mm in the frame
        for (x = [-SOL_HOLE_X, SOL_HOLE_X], hz = SOL_HOLE_Z) {
            translate([x, FACE_Y - 1, SOL_TOP - hz]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = SPINE_T + 2);
            translate([x, SPINE_Y2 - 2, SOL_TOP - hz]) rotate([-90, 0, 0]) cylinder(d = 6.5, h = 3);
        }
        // wire windows, pointed tops so they print without support
        win = [[-7, SOL_BOT + 3], [7, SOL_BOT + 3], [7, SOL_TOP - 13], [0, SOL_TOP - 6], [-7, SOL_TOP - 13]];
        yz_extrude(win, -SIDE_OUT - 1, 2*SIDE_OUT + 2);
        // bench screws
        for (x = [-27, TOWER_X2 + 1], y = [FRONT_Y - 7, SPINE_Y2 - 5])
            translate([x, y, BASE_TOP - BASE_T - 1]) cylinder(d = 4.5, h = BASE_T + 2);
    }
}

// ================================================================ table + stylus guide
module table(hex_af = HEX_AF) {
    difference() {
        union() {
            translate([TABLE_X0, -TABLE_Y, -TABLE_T]) cube([FENCE_X - 0.5 - TABLE_X0, 2*TABLE_Y, TABLE_T]);
            translate([0, 0, BOSS_BOT]) cylinder(d = BOSS_D, h = -TABLE_T - BOSS_BOT + 0.01);
        }
        // hex guide for the standoff (stops it turning, keeps the tip on the die)
        translate([0, 0, BOSS_BOT - 1]) cylinder(d = hexd(hex_af), h = SO_TOP_REST - BOSS_BOT + 1, $fn = 6);
        translate([0, 0, BOSS_BOT - 0.01]) cylinder(d1 = hexd(hex_af) + 1.4, d2 = hexd(hex_af), h = 0.7, $fn = 6);
        // round bore where the lock nut travels, so the nut needn't line up with the hex
        translate([0, 0, SO_TOP_REST - 0.01]) cylinder(d = NUT_BORE, h = -SKIN - SO_TOP_REST + 0.01);
        // stylus hole through the skin
        translate([0, 0, -SKIN - 1]) cylinder(d = STYLUS_HOLE, h = SKIN + 2);
        // counterbored, oversize screw holes (+/-1.1 mm adjustment), heads below the paper
        for (p = TABLE_SCREWS) {
            translate([p[0], p[1], -TABLE_T - 1]) cylinder(d = 5.2, h = TABLE_T + 2);
            translate([p[0], p[1], -2]) cylinder(d = 9.5, h = 3);
        }
        // spacing ticks along y: 2.5 mm dot pitch and 6.0 mm cell pitch, zero on the axis
        for (i = [-13:13]) translate([TABLE_X0 + 1, 2.5*i - 0.25, -0.4]) cube([4, 0.5, 1]);
        for (j = [-5:5]) translate([TABLE_X0 + 6, 6*j - 0.3, -0.4]) cube([j == 0 ? 12 : 4, 0.6, 1]);
    }
}

// ================================================================ die arm
module arm(tap = DIE_TAP) {
    difference() {
        union() {
            translate([-12, -ARM_W/2, ARM_Z0]) cube([TOWER_X2 + 12, ARM_W, ARM_T]);
            hull() {
                translate([0, 0, NOSE_Z]) cylinder(d = NOSE_D - 1.5, h = 0.01);
                translate([0, 0, NOSE_Z + 0.75]) cylinder(d = NOSE_D, h = ARM_Z0 - NOSE_Z - 0.75 + 0.01);
            }
        }
        // die hole: tap through from the top
        translate([0, 0, NOSE_Z - 1]) cylinder(d = tap, h = ARM_Z0 + ARM_T - NOSE_Z + 2);
        // oversize holes: slide the arm +/-1.1 mm to centre the socket on the stylus
        for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 - 1]) cylinder(d = 5.2, h = ARM_T + 2);
    }
}

// ================================================================ fence shims
// Lay one against the fence to move the paper 2.5 / 5 / 10 mm (one dot row,
// two dot rows, one braille line) away from it.
SHIMS = [2.5, 5, 10];
module shims() {
    for (k = [0:len(SHIMS) - 1]) translate([0, k*16, 0]) cube([SHIMS[k], 60, 3]);
}

// ================================================================ hardware (for previews)
module sol_frame() {   // D-frame of 1.5 mm steel
    translate([-SOL_W/2, FACE_Y - 1.5, SOL_BOT]) cube([SOL_W, 1.5, SOL_LEN]);
    difference() {
        union() {
            translate([-SOL_W/2, FRONT_Y, SOL_TOP - 1.5]) cube([SOL_W, SOL_D, 1.5]);
            translate([-SOL_W/2, FRONT_Y, SOL_BOT]) cube([SOL_W, SOL_D, 1.5]);
        }
        translate([0, 0, SOL_TOP - 2]) cylinder(d = 3.4, h = 3);   // push rod
        translate([0, 0, SOL_BOT - 1]) cylinder(d = 8, h = 3);     // plunger
    }
}
module sol_coil() {
    difference() {
        translate([0, 0, SOL_BOT + 1.5]) cylinder(d = 20, h = SOL_LEN - 3);
        translate([0, 0, SOL_BOT]) cylinder(d = 8, h = SOL_LEN - 1.5 - POLE);   // plunger bore
        translate([0, 0, SOL_BOT]) cylinder(d = 3.4, h = SOL_LEN + 1);          // push rod hole in the pole
    }
}
// At rest the plunger face sits one stroke below the pole piece; energised, it closes that gap.
POLE = 3;
module plunger(lift = 0) translate([0, 0, lift]) {
    face = SOL_TOP - 1.5 - POLE - STROKE;
    translate([0, 0, SOL_BOT - TAIL + 6]) cylinder(d = 7, h = face - (SOL_BOT - TAIL + 6));
    translate([0, 0, SOL_BOT - TAIL + 4]) cylinder(d = 7.5, h = 2);                 // e-clip / spring seat
    translate([0, 0, face]) cylinder(d = 3, h = SOL_TOP + 6 - face);                // push rod through the pole
}
module standoff(lift = 0) translate([0, 0, SOL_TOP + lift])
    difference() {
        cylinder(d = hexd(SO_AF), h = SO_LEN, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 2.5, h = SO_LEN + 2);
    }
module nut(lift = 0) translate([0, 0, SO_TOP_REST + lift])
    difference() {
        cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 2.5, h = NUT_T + 2);
    }
module stylus(lift = 0) translate([0, 0, lift]) {
    tip = TIP_TOP - STROKE;
    translate([0, 0, tip - 16]) cylinder(d = 3, h = 16 - DOG_L);                    // thread
    hull() {                                                                         // dog point filed round
        translate([0, 0, tip - DOG_L]) cylinder(d = DOG_D, h = 0.6);
        translate([0, 0, tip - 0.75]) sphere(r = 0.75);
    }
}
module die_screw() {
    difference() {
        translate([0, 0, GAP]) cylinder(d = 3, h = DIE_LEN);
        translate([0, 0, GAP - 0.01]) cylinder(d = hexd(SOCKET_AF), h = 1.5, $fn = 6);  // the die
    }
}
module die_nuts() {
    top = ARM_Z0 + ARM_T;
    translate([0, 0, top]) cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);                    // lock nut
    translate([0, 0, GAP + DIE_LEN - 3]) cylinder(d = hexd(NUT_AF), h = 3.2, $fn = 6);        // acorn nut
    translate([0, 0, GAP + DIE_LEN + 0.2]) scale([1, 1, 0.9]) sphere(d = 5.5);
}
module paper() translate([-28, -TABLE_Y, 0]) cube([FENCE_X + 28, 2*TABLE_Y, PAPER]);

// ================================================================ assembly
module assembly(lift = STROKE_POS*STROKE) {
    color("SteelBlue")        frame();
    color("LightSteelBlue")   table();
    color("SteelBlue")        arm();
    color("DimGray")          sol_frame();
    color("Chocolate")        sol_coil();
    color("Silver")           plunger(lift);
    color("Goldenrod")        standoff(lift);
    color("Silver")           nut(lift);
    color("Gainsboro")        stylus(lift);
    color("Silver")           die_screw();
    color("DarkGray")         die_nuts();
    color("White", 0.9)       paper();
}

// print orientation: frame upright, table paper-face down, arm top-face down
if (PART == "frame_print") frame();
if (PART == "table_print") rotate([180, 0, 0]) table();
if (PART == "arm_print")   rotate([180, 0, 0]) arm();

if (PART == "assembly")   assembly();
if (PART == "section")    difference() { assembly(); translate([-100, -200, -200]) cube([300, 200, 400]); }
if (PART == "frame")      frame();
if (PART == "table")      table();
if (PART == "arm")        arm();
if (PART == "shims")      shims();
if (PART == "sol_frame")  sol_frame();
if (PART == "sol_coil")   sol_coil();
if (PART == "plunger")    plunger();
if (PART == "standoff")   standoff();
if (PART == "nut")        nut();
if (PART == "stylus")     stylus();
if (PART == "die_screw")  die_screw();
if (PART == "die_nuts")   die_nuts();
if (PART == "paper")      paper();

echo(str("tip rest ", TIP_TOP - STROKE, ", tip end of stroke ", TIP_TOP,
         ", paper contact after ", STROKE - TIP_TOP + 0, " mm",
         ", die face ", GAP, ", solenoid frame ", SOL_BOT, "..", SOL_TOP,
         ", base ", BASE_TOP - BASE_T, ", hex guide ", BOSS_BOT, "..", SO_TOP_REST));
