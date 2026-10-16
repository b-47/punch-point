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
// The solenoid slots in without screws into its own holes, so nothing depends
// on where they are: its bottom plate sits on ledges in the side walls, two
// jack screws in lips over the top plate's front corners hold it down (any
// frame length from 25 to 28 mm), and zip ties across the front keep it in.
//
// Coordinates (mm): punch axis x 0, y 0. z 0 = top of the paper table.
// A paper strip slides along y with its edge on the fence at x = FENCE_X.
//
// Printed parts (PETG):  frame, table (hex fit variants), arm (M3 or M4 die),
// fence shims, and a coupon for checking the solenoid fit first.
// PART selects what is rendered; the default is the assembly.

PART = "assembly";  // assembly | section | frame | table | arm | shims | coupon
                    // frame_print | table_print | arm_print   (print orientation)
                    // sol_frame | sol_coil | plunger | standoff | nut | stylus
                    // die_screw | die_nuts | paper
STROKE_POS = 0;     // 0 = rest, 1 = end of stroke (assembly / section only)
$fn = 48;

// ---------- solenoid ----------
SOL_W        = 22;         // frame width across the back face (x); listings agree on 22
SOL_D        = 25;         // frame depth from the back face (y); listings agree on 25
AXIS_TO_FACE = 12.5;       // plunger axis to the back face, assumed central; the boss slot takes +/-1.5
L_MIN        = 25;         // frame lengths along the plunger axis that the pocket takes
L_MAX        = 28;
SOL_LEN      = 27;         // for the previews only; listings say 26 or 27
STROKE       = 10;
TAIL_ROOM    = 29;         // bottom plate to the base; the base window gives 4 mm more
SOL_HOLE_X   = 6;          // optional M3 holes in the spine, from the v2 datasheet, unverified
SOL_HOLE_Z   = [6.5, 21];  // measured from the push-rod end of a 27 mm frame

// ---------- stylus stack ----------
SO_AF      = 5.5;   // standoff across flats
SO_LEN     = 18;
NUT_AF     = 5.5;
NUT_T      = 2.4;
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
TABLE_T     = 3;
DECK_T      = 3;
WALL        = 3;
SPINE_T     = 4;
GUSSET_T    = 3;
SIDE_CLR    = 0.5;  // 23 mm pocket for a 22 mm frame
BOSS_D      = 11;
FENCE_X     = 20;   // fence to punch axis
TOWER_X2    = 32;
TOWER_Y     = 11;   // tower and fence run y -11 .. 11
ARM_Z0      = 5;
ARM_T       = 10;
ARM_W       = 18;
NOSE_D      = 8;
BASE_T      = 4;
CB_DEPTH    = 1.8;  // counterbore for M3 button heads (1.65 mm tall)
LEDGE_W     = 2;    // ledges reach in under the bottom plate's side edges
LIP_IN      = 6;    // lips reach in to |x| = 6: clear of the boss and its +/-1.5 mm of slot travel
LIP_Y       = [-12.5, -6];
LIP_H       = 8.5;
CLAMP       = [9, -9.25]; // jack screw position (x mirrored)
FRONT_EXT   = 4;    // side walls run past the solenoid's front face to carry the zip-tie slots
TIE_W       = 4.5;  // zip-tie slot, for ties up to 4 mm wide
TIE_T       = 2;

// ---------- derived ----------
// The stylus stack is laid out for the longest body; a shorter one sits lower
// and its stylus screws further out of the standoff (6 mm at 28, 9 mm at 25).
SO_TOP_REST = TIP_TOP - 6 - STROKE;   // standoff top at rest with a 28 mm body
SOL_TOP_NOM = SO_TOP_REST - SO_LEN;
LEDGE_TOP   = SOL_TOP_NOM - L_MAX;    // the bottom plate sits here whatever the length
SOL_BOT     = LEDGE_TOP;
SOL_TOP     = SOL_BOT + SOL_LEN;      // previews
STYLUS_OUT  = TIP_TOP - STROKE - (SOL_TOP + SO_LEN);
BOSS_BOT    = SOL_TOP_NOM + 2;
LIP_Z0      = SOL_TOP_NOM + 0.3;      // a 28 mm body still slides under the lips
DECK_TOP    = -TABLE_T;
DECK_BOT    = DECK_TOP - DECK_T;
BASE_TOP    = LEDGE_TOP - TAIL_ROOM;
NOSE_Z      = GAP + DIE_OUT;
FACE_Y      = AXIS_TO_FACE;
FRONT_Y     = FACE_Y - SOL_D;
WALL_Y0     = FRONT_Y - FRONT_EXT;
SPINE_Y2    = FACE_Y + SPINE_T;
SIDE_IN     = SOL_W/2 + SIDE_CLR;
SIDE_OUT    = SIDE_IN + WALL;
WING        = TOWER_X2 - SIDE_OUT;
BASE_X0     = -32;
BASE_X1     = TOWER_X2 + 6;
BASE_Y0     = FRONT_Y - 12;

TABLE_X0 = -36;
TABLE_Y  = 28;
TABLE_SCREWS = [[-10.5, -9], [-10.5, 9], [10.5, -9], [10.5, 9]];
ARM_SCREWS   = [[26, -5], [26, 5]];
BENCH_HOLES  = [[-27, BASE_Y0 + 4.5], [-27, SPINE_Y2 - 4], [TOWER_X2 + 1, BASE_Y0 + 4.5], [TOWER_X2 + 1, SPINE_Y2 - 4]];
TIE_Z        = [LEDGE_TOP + 1.5, LIP_Z0 - 2.5];

function hexd(af) = af / cos(30);   // circumscribed diameter for a $fn = 6 cylinder

// Extrude a (y, z) polygon along +x, starting at x0.
module yz_extrude(pts, x0, len) {
    multmatrix([[0, 0, 1, x0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = len) polygon(pts);
}
// Extrude an (x, z) polygon along +y, starting at y0.
module xz_extrude(pts, y0, len) {
    multmatrix([[1, 0, 0, 0], [0, 0, 1, y0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = len) polygon(pts);
}
// Window with a 45 degree peak, so it prints in a vertical wall without support.
function arch(a0, a1, z0, z1) = let (h = (a1 - a0) / 2)
    [[a0, z0], [a1, z0], [a1, z1 - h], [(a0 + a1) / 2, z1], [a0, z1 - h]];

// ================================================================ frame
module frame() {
    difference() {
        union() {
            // base, with windows wherever nothing stands on it
            translate([BASE_X0, BASE_Y0, BASE_TOP - BASE_T]) cube([BASE_X1 - BASE_X0, SPINE_Y2 - BASE_Y0, BASE_T]);
            // side walls locate the solenoid in x
            for (x0 = [-SIDE_OUT, SIDE_IN])
                translate([x0, WALL_Y0, BASE_TOP]) cube([WALL, FACE_Y - WALL_Y0, DECK_BOT - BASE_TOP]);
            // spine: the back datum; the solenoid's back face rests against it
            translate([-SIDE_OUT, FACE_Y, BASE_TOP]) cube([2*SIDE_OUT, SPINE_T, DECK_TOP - BASE_TOP]);
            // deck over the solenoid carries the table; it bridges the side walls when printed upright
            translate([-SIDE_OUT, FRONT_Y, DECK_BOT]) cube([2*SIDE_OUT, SPINE_Y2 - FRONT_Y, DECK_T]);
            // wing under the tower, carried by two 45 degree gussets so it prints without support
            translate([SIDE_OUT - 0.01, -TOWER_Y, DECK_BOT]) cube([WING + 0.01, 2*TOWER_Y, DECK_T]);
            for (y0 = [-TOWER_Y, TOWER_Y - GUSSET_T]) hull() {
                translate([SIDE_OUT - 0.01, y0, DECK_BOT - WING]) cube([0.01, GUSSET_T, WING]);
                translate([SIDE_OUT, y0, DECK_BOT - 0.01]) cube([WING, GUSSET_T, 0.01]);
            }
            // tower: its inner face is the paper fence, its top carries the arm
            translate([FENCE_X, -TOWER_Y, DECK_TOP]) cube([TOWER_X2 - FENCE_X, 2*TOWER_Y, ARM_Z0 - DECK_TOP]);
            for (s = [-1, 1]) {
                // ledges under the bottom plate's side edges take the strike reaction
                mirror([s < 0 ? 1 : 0, 0, 0])
                    xz_extrude([[SIDE_IN + 0.01, LEDGE_TOP], [SIDE_IN - LEDGE_W, LEDGE_TOP],
                                [SIDE_IN - LEDGE_W, LEDGE_TOP - 0.4], [SIDE_IN + 0.01, LEDGE_TOP - 0.4 - LEDGE_W]],
                               FRONT_Y, FACE_Y - FRONT_Y);
                // lips over the top plate's front corners, 45 degree undersides; each takes a jack screw
                mirror([s < 0 ? 1 : 0, 0, 0])
                    xz_extrude([[SIDE_IN + 0.01, LIP_Z0], [SIDE_IN + 0.01, LIP_Z0 + LIP_H], [LIP_IN, LIP_Z0 + LIP_H],
                                [LIP_IN, LIP_Z0 + SIDE_IN - LIP_IN]],
                               LIP_Y[0], LIP_Y[1] - LIP_Y[0]);
            }
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
        for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 - 10]) cylinder(d = 2.8, h = 11);
        // jack screws, self-tapping, pressing down on the top plate
        for (s = [-1, 1]) translate([s * CLAMP[0], CLAMP[1], LIP_Z0 - 1]) cylinder(d = 2.8, h = LIP_H + 2);
        // optional M3 holes for the solenoid's own threads, if they turn out to line up
        for (x = [-SOL_HOLE_X, SOL_HOLE_X], hz = SOL_HOLE_Z)
            translate([x, FACE_Y - 1, SOL_TOP - hz]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = SPINE_T + 2);
        // side windows: wires out, plastic saved; walls stay solid where the ledges, lips and gussets attach
        yz_extrude(arch(-9, 9, BASE_TOP + 4, LEDGE_TOP - 3.5), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
        yz_extrude(arch(-9, 9, LEDGE_TOP + 2, LIP_Z0 - 1.5), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
        // zip-tie slots across the front: the ties run just in front of the solenoid's face
        for (z = TIE_Z)
            translate([-SIDE_OUT - 1, WALL_Y0 + (FRONT_EXT - TIE_T) / 2, z - TIE_W / 2]) cube([2*SIDE_OUT + 2, TIE_T, TIE_W]);
        // back window under the solenoid: reach the plunger tail to push it up when lining things up
        xz_extrude(arch(-9, 9, BASE_TOP + 4, LEDGE_TOP - 4), FACE_Y - 1, SPINE_T + 2);
        // base windows: under the plunger (open to the front, so a long tail slides in with the
        // body) and either side, leaving the corners for bench screws
        for (w = [[-SIDE_IN, SIDE_IN, BASE_Y0 - 1, FACE_Y], [BASE_X0 + 4, -SIDE_OUT - 4, BASE_Y0 + 9, SPINE_Y2 - 8.5],
                  [SIDE_OUT + 4, BASE_X1 - 4, BASE_Y0 + 9, SPINE_Y2 - 8.5]])
            translate([w[0], w[2], BASE_TOP - BASE_T - 1]) cube([w[1] - w[0], w[3] - w[2], BASE_T + 2]);
        // bench screws
        for (p = BENCH_HOLES) translate([p[0], p[1], BASE_TOP - BASE_T - 1]) cylinder(d = 4.5, h = BASE_T + 2);
    }
}

// The pocket around the ledges, a few grams: print it first and check the solenoid
// slides in, sits flat on the ledges, and its plunger and spring clear them.
module coupon() intersection() {
    frame();
    translate([-SIDE_OUT - 1, BASE_Y0 - 1, LEDGE_TOP - 6]) cube([2*SIDE_OUT + 2, SPINE_Y2 - BASE_Y0 + 2, 12]);
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
        // round bore where the lock nut travels
        translate([0, 0, SO_TOP_REST - 0.01]) cylinder(d = NUT_BORE, h = -SKIN - SO_TOP_REST + 0.01);
        // stylus hole through the skin
        translate([0, 0, -SKIN - 1]) cylinder(d = STYLUS_HOLE, h = SKIN + 2);
        // counterbored, oversize screw holes (+/-1.1 mm adjustment), heads below the paper
        for (p = TABLE_SCREWS) {
            translate([p[0], p[1], -TABLE_T - 1]) cylinder(d = 5.2, h = TABLE_T + 2);
            translate([p[0], p[1], -CB_DEPTH]) cylinder(d = 9.5, h = 3);
        }
        // spacing ticks along y: 2.5 mm dot pitch and 6.0 mm cell pitch, zero on the axis
        for (i = [-10:10]) translate([TABLE_X0 + 1, 2.5*i - 0.25, -0.4]) cube([4, 0.5, 1]);
        for (j = [-4:4]) translate([TABLE_X0 + 6, 6*j - 0.3, -0.4]) cube([j == 0 ? 12 : 4, 0.6, 1]);
    }
}

// ================================================================ die arm
module arm(tap = DIE_TAP) {
    difference() {
        union() {
            hull() {   // rounded just past the die nose, square at the tower
                translate([0, 0, ARM_Z0]) cylinder(d = ARM_W, h = ARM_T);
                translate([TOWER_X2 - 1, -ARM_W/2, ARM_Z0]) cube([1, ARM_W, ARM_T]);
            }
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
    for (k = [0:len(SHIMS) - 1]) translate([0, k*14, 0]) cube([SHIMS[k], 40, 2]);
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
        translate([0, 0, SOL_BOT + 1.5]) cylinder(d = 19, h = SOL_LEN - 3);
        translate([0, 0, SOL_BOT]) cylinder(d = 8, h = SOL_LEN - 1.5 - POLE);   // plunger bore
        translate([0, 0, SOL_BOT]) cylinder(d = 3.4, h = SOL_LEN + 1);          // push rod hole in the pole
    }
}
// At rest the plunger face sits one stroke below the pole piece; energised, it closes that gap.
// The tail below the frame is drawn at the worst case: all 31 mm of plunger outside the frame.
POLE = 3;
TAIL = 31;
module plunger(lift = 0) translate([0, 0, lift]) {
    face = SOL_TOP - 1.5 - POLE - STROKE;
    translate([0, 0, SOL_BOT - TAIL + 2]) cylinder(d = 7.4, h = face - (SOL_BOT - TAIL + 2));
    translate([0, 0, SOL_BOT - TAIL]) cylinder(d = 7.5, h = 2);                    // e-clip / spring seat
    translate([0, 0, face]) cylinder(d = 3, h = SOL_TOP + 6 - face);                // push rod through the pole
}
module standoff(lift = 0) translate([0, 0, SOL_TOP + lift])
    difference() {
        cylinder(d = hexd(SO_AF), h = SO_LEN, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 2.5, h = SO_LEN + 2);
    }
module nut(lift = 0) translate([0, 0, SOL_TOP + SO_LEN + lift])
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

// print orientation: frame and coupon upright, table paper-face down, arm top-face down
if (PART == "frame_print") frame();
if (PART == "table_print") rotate([180, 0, 0]) table();
if (PART == "arm_print")   rotate([180, 0, 0]) arm();

if (PART == "assembly")   assembly();
if (PART == "section")    difference() { assembly(); translate([-100, -200, -200]) cube([300, 200, 400]); }
if (PART == "frame")      frame();
if (PART == "coupon")     coupon();
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

echo(str("frame length ", SOL_LEN, ": stylus out ", STYLUS_OUT, " mm, top plate ", SOL_TOP,
         ", ledges ", LEDGE_TOP, ", lips from ", LIP_Z0, ", boss gap ", BOSS_BOT - SOL_TOP,
         ", tail room to bench ", LEDGE_TOP - (BASE_TOP - BASE_T)));
