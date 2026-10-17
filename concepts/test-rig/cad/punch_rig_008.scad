// Punch Point braille punch test rig, version 008
//
// One JF-0826B-class solenoid, one steel stylus, one metal die.
// Solenoid sizes come from the seller's dimension drawing (22 x 25 x 27 mm frame,
// M3 push rod, M3 holes 12 x 14.5 mm apart, plunger tail 20 mm at rest).
// Stylus and die:
//   stylus = M3 x 16 dog-point set screw, tip filed round, locked in an
//            M3 x 18 hex standoff that rides in a close-fit printed hex bore
//   die    = hex socket of an M3 x 25 set screw (socket end down), threaded
//            into the arm; two nuts locked together on top turn it
//            to set the dot height
// The solenoid sits below the paper and pushes up, so dots come out facing up
// and gravity resets the plunger. Strike loads close inside one C-frame.
//
// The solenoid slides in from the front onto ledges in the side walls, with the
// face that has its two threaded M3 holes against the back wall (the spine).
// Two M3 x 6 screws through slots in the spine hold it. Small fixed lips over the
// top plate stop it jumping if the screws are out, and once the table is on, its
// stylus guide keeps the solenoid from sliding forward.
//
// Fitting the standoff in place of the acorn nut moves the plunger's rest stop.
// The stroke spacer sets it back to the full 10 mm stroke.
//
// Coordinates (mm): punch axis x 0, y 0. z 0 = top of the paper table.
// A paper strip slides along y with its edge on the fence at x = FENCE_X.
//
// Printed parts (PLA for the first test):  frame, table (hex fit variants), arm (M3 or M4 die),
// fence shims and a stroke spacer.
// PART selects what is rendered; the default is the assembly.

PART = "assembly";  // assembly | section | frame | table | arm | shims | spacer
                    // frame_print | table_print | arm_print   (print orientation)
                    // sol_frame | sol_coil | plunger | standoff | nut | stylus
                    // back_screws | die_screw | die_nuts | paper
STROKE_POS = 0;     // 0 = rest, 1 = end of stroke (assembly / section only)
$fn = 48;

// ---------- solenoid (seller's drawing) ----------
SOL_W        = 22;         // frame width across the back face (x)
SOL_D        = 25;         // frame depth from the back face (y); plates at front and back, coil open at the sides
AXIS_TO_FACE = 12.5;       // plunger axis to the back face: central in the drawing; the boss slot takes +/-1.5
L_MIN        = 25;         // frame lengths along the plunger axis that the pocket takes
L_MAX        = 28;
DRAWING_LEN  = 27;         // the drawing's length: places the spine slots and the lips
SOL_LEN      = DRAWING_LEN;   // the solenoid in the previews; collision checks vary it
PLATE_T      = 2;          // frame steel, previews only
STROKE       = 10;
TAIL_ROOM    = 29;         // bottom plate to the base; the base window gives 4 mm more
TAIL         = 20;         // plunger past the bottom plate at rest: 11 mm of spring, then 9 mm of slotted end
SOL_HOLE_X   = 6;          // the solenoid's M3 holes, 12 mm apart across the back face
SOL_HOLE_Z   = [6.25, 20.75];  // and 14.5 mm apart along it, from the push-rod end
SLOT_TRAVEL  = 1;          // spine slots run +/-1 mm along z, since the ledges set the height
SLOT_W       = 4.0;        // and are 4 mm wide: +/-0.5 mm across for an M3 screw

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
SKIN        = 1.2;  // table skin the stylus pokes through; thin so the lock nut clears it at the top of the stroke
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
CB_D        = 7.4;  // a 5.7 mm head with room to move +/-0.6 mm with the table
TABLE_HOLE  = 4.2;  // oversize: the table slides +/-0.6 mm to line the guide up with the plunger
SLOT_HALF   = 7;    // the boss slot in the deck is 14 mm wide
SLOT_BACK   = 7;    // and runs from the front to 7 mm behind the stylus axis
DECK_SLOPE  = 55;   // degrees: the slopes under the deck, steeper than the ~51 a layer can creep out
LEDGE_W     = 2;    // ledges reach in under the bottom plate's side edges
LIP_IN      = 8.5;  // lips reach 2.5 mm over the top plate's side edges
LIP_Y       = [-12.5, -6];
LIP_H       = 4;
LIP_GAP     = 0.2;  // over the drawing's 27 mm frame at the wall; 0.7 mm over the plate's edge
FRONT_EXT   = 0;    // side walls end at the solenoid's front face

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
FRAME_TOP   = LEDGE_TOP + DRAWING_LEN;   // the drawing's top plate: the frame is built around it
LIP_Z0      = FRAME_TOP + LIP_GAP;
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
TABLE_SCREWS = [[-11, 1], [-11, 13], [11, 1], [11, 13]];   // behind the deck's front edge
ARM_SCREWS   = [[26, -5], [26, 5]];
BENCH_HOLES  = [[-27, BASE_Y0 + 4.5], [-27, SPINE_Y2 - 4], [TOWER_X2 + 1, BASE_Y0 + 4.5], [TOWER_X2 + 1, SPINE_Y2 - 4]];

function hexd(af) = af / cos(30);   // circumscribed diameter for a $fn = 6 cylinder

// Stepped bridge (from pc-case's joinery.scad), for a recess that opens onto the print bed with a
// smaller hole carrying on through its ceiling, such as a counterbore. Bridged straight, every line
// that crosses the hole ends in mid-air and hangs down into it. Instead, the first layer over the
// recess leaves a slot as wide as the hole right across the recess (its lines run along the slot and
// land on the recess wall at both ends), and the next leaves only the hole's own square, bridged
// across the slot. The round hole starts on top of that. Local frame: the ceiling at z = 0, the hole
// going +z, the slot along x. `w`: the hole's width. children(): the recess, reaching past z = 0.
// SUBTRACTIVE.
STEP_H = 0.2;   // one print layer
module bridge_steps(w) {
    intersection() {
        translate([0, 0, STEP_H/2]) cube([1000, w, STEP_H + 0.02], center = true);
        children();
    }
    translate([0, 0, 1.5*STEP_H]) cube([w, w, STEP_H + 0.02], center = true);
}

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
                // small lips over the top plate's front corners stop it jumping; 45 degree undersides
                mirror([s < 0 ? 1 : 0, 0, 0])
                    xz_extrude([[SIDE_IN + 0.01, LIP_Z0], [SIDE_IN + 0.01, LIP_Z0 + LIP_H], [LIP_IN, LIP_Z0 + LIP_H],
                                [LIP_IN, LIP_Z0 + SIDE_IN - LIP_IN]],
                               LIP_Y[0], LIP_Y[1] - LIP_Y[0]);
                // a slope under the deck along each side wall, from the wall to the boss slot, so the
                // deck beside the slot prints on it instead of hanging over the solenoid pocket
                mirror([s < 0 ? 1 : 0, 0, 0])
                    xz_extrude([[SIDE_IN + 0.01, DECK_BOT + 0.01], [SIDE_IN + 0.01, DECK_BOT - (SIDE_IN - SLOT_HALF)*tan(DECK_SLOPE)],
                                [SLOT_HALF, DECK_BOT + 0.01]],
                               FRONT_Y, FACE_Y - FRONT_Y);
            }
        }
        // slot for the guide boss, open to the front: the solenoid slides in with its stylus
        // already fitted. Square at the back, so the deck behind it bridges straight across
        translate([-SLOT_HALF, FRONT_Y - 1, DECK_BOT - 1]) cube([2*SLOT_HALF, SLOT_BACK - FRONT_Y + 1, DECK_T + 2]);
        // table screws, self-tapping; deep enough that a screw tip over a wall finds a hole
        for (p = TABLE_SCREWS) translate([p[0], p[1], DECK_BOT - 3]) cylinder(d = 2.8, h = DECK_T + 4);
        // arm screws, self-tapping
        for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 - 10]) cylinder(d = 2.8, h = 11);
        // slots for the two M3 x 6 screws into the solenoid's own threaded holes; both
        // diagonals, since the drawing shows one pair but not which way round it will face
        for (x = [-SOL_HOLE_X, SOL_HOLE_X], hz = SOL_HOLE_Z)
            hull() for (dz = [-SLOT_TRAVEL, SLOT_TRAVEL])
                translate([x, FACE_Y - 1, FRAME_TOP - hz + dz]) rotate([-90, 0, 0]) cylinder(d = SLOT_W, h = SPINE_T + 2);
        // side windows: wires out, plastic saved; walls stay solid where the ledges, lips and gussets attach
        yz_extrude(arch(-9, 9, BASE_TOP + 4, LEDGE_TOP - 3.5), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
        yz_extrude(arch(-9, 9, LEDGE_TOP + 2, LIP_Z0 - 1.5), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
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
        // counterbored, oversize screw holes, heads below the paper. The table prints paper face
        // down, so each counterbore opens onto the bed and gets a stepped bridge over it
        for (p = TABLE_SCREWS) translate([p[0], p[1], 0]) {
            translate([0, 0, -TABLE_T - 1]) cylinder(d = TABLE_HOLE, h = TABLE_T + 2);
            translate([0, 0, -CB_DEPTH]) cylinder(d = CB_D, h = CB_DEPTH + 1);
            translate([0, 0, -CB_DEPTH]) mirror([0, 0, 1]) bridge_steps(TABLE_HOLE) cylinder(d = CB_D, h = 2, center = true);
        }
        // spacing ticks along y: 2.5 mm dot pitch and 6.0 mm cell pitch, zero on the axis
        for (i = [-10:10]) translate([TABLE_X0 + 1, 2.5*i - 0.25, -0.4]) cube([4, 0.5, 1]);
        for (j = [-4:4]) translate([TABLE_X0 + 6, 6*j - 0.3, -0.4]) cube([j == 0 ? 12 : 4, 0.6, 1]);
        // the hex size underneath, so the two fits can be told apart
        under_label(str(floor(hex_af), ".", round((hex_af - floor(hex_af))*10)), [-25, -15], -TABLE_T);
    }
}
// Text cut 0.6 mm into a downward face, reading the right way round from below
module under_label(s, xy, z) translate([xy[0], xy[1], z - 0.01]) mirror([1, 0, 0])
    linear_extrude(height = 0.61) text(s, size = 5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");

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
        // die size underneath
        under_label(tap > 3 ? "M4" : "M3", [12.5, 0], ARM_Z0);
    }
}

// ================================================================ fence shims
// Lay one against the fence to move the paper 2.5 / 5 / 10 mm (one dot row,
// two dot rows, one braille line) away from it.
SHIMS = [2.5, 5, 10];
module shims() {
    for (k = [0:len(SHIMS) - 1]) translate([k*14, 0, 0]) cube([SHIMS[k], 40, 2]);   // side by side, 14 mm apart
}

// ================================================================ stroke spacer
// A block one stroke thick with a slot for the push rod. With the plunger pushed
// fully in, the standoff is screwed down onto it, so at rest the plunger has its
// full stroke before the standoff lands on the frame.
SPACER = [14, 22];   // footprint; the slot runs in from one short end
module spacer() {
    difference() {
        translate([-SPACER[0]/2, -SPACER[0]/2, 0]) cube([SPACER[0], SPACER[1], STROKE]);
        hull() {
            translate([0, 0, -1]) cylinder(d = 3.6, h = STROKE + 2);
            translate([0, -SPACER[0], -1]) cylinder(d = 3.6, h = STROKE + 2);
        }
    }
}

// ================================================================ hardware (for previews)
module sol_frame() {   // steel box: plates at the back and front, end plates top and bottom, coil open at the sides
    for (y0 = [FACE_Y - PLATE_T, FRONT_Y])
        difference() {
            translate([-SOL_W/2, y0, SOL_BOT]) cube([SOL_W, PLATE_T, SOL_LEN]);
            for (k = [0, 1])   // M3 holes on one diagonal, as drawn
                translate([(2*k - 1)*SOL_HOLE_X, y0 - 1, SOL_TOP - SOL_HOLE_Z[k]]) rotate([-90, 0, 0]) cylinder(d = 3, h = PLATE_T + 2);
        }
    difference() {
        union() {
            translate([-SOL_W/2, FRONT_Y, SOL_TOP - PLATE_T]) cube([SOL_W, SOL_D, PLATE_T]);
            translate([-SOL_W/2, FRONT_Y, SOL_BOT]) cube([SOL_W, SOL_D, PLATE_T]);
        }
        translate([0, 0, SOL_TOP - PLATE_T - 1]) cylinder(d = 3.4, h = PLATE_T + 2);   // push rod
        translate([0, 0, SOL_BOT - 1]) cylinder(d = 8, h = PLATE_T + 2);              // plunger
    }
}
module sol_coil() {
    difference() {
        translate([0, 0, SOL_BOT + PLATE_T]) cylinder(d = 19, h = SOL_LEN - 2*PLATE_T);
        translate([0, 0, SOL_BOT]) cylinder(d = 8, h = SOL_LEN - PLATE_T - POLE);   // plunger bore
        translate([0, 0, SOL_BOT]) cylinder(d = 3.4, h = SOL_LEN + 1);              // push rod hole in the pole
    }
}
// At rest the plunger face sits one stroke below the pole piece; energised, it closes that gap.
// Below the frame: a spring to a washer 11 mm down, then the slotted end, 20 mm in all.
POLE = 3;
module plunger(lift = 0) translate([0, 0, lift]) {
    face = SOL_TOP - PLATE_T - POLE - STROKE;
    translate([0, 0, SOL_BOT - TAIL]) cylinder(d = 7.5, h = face - (SOL_BOT - TAIL));
    translate([0, 0, SOL_BOT - 11 - 1]) cylinder(d = 11, h = 1);                    // washer and e-clip
    translate([0, 0, face]) cylinder(d = 3, h = SOL_TOP + 6 - face);                // push rod through the pole
}
module spring(lift = 0) {   // the return spring between the bottom plate and the washer
    top = SOL_BOT;
    bot = SOL_BOT - 11 + lift;
    turns = 5;
    for (i = [0:turns*8 - 1]) hull() for (j = [i, i + 1])
        translate([4.5*cos(j*45), 4.5*sin(j*45), bot + (top - bot)*j/(turns*8)]) sphere(d = 0.8, $fn = 6);
}
// M3 x 6 socket head screws and washers through the back wall into the solenoid's holes
module back_screws() for (k = [0, 1]) translate([(2*k - 1)*SOL_HOLE_X, 0, FRAME_TOP - SOL_HOLE_Z[k]]) {
    translate([0, SPINE_Y2 + 0.5 - 6, 0]) rotate([-90, 0, 0]) cylinder(d = 3, h = 6);     // shank
    translate([0, SPINE_Y2, 0]) rotate([-90, 0, 0]) cylinder(d = 7, h = 0.5);           // washer
    translate([0, SPINE_Y2 + 0.5, 0]) rotate([-90, 0, 0]) cylinder(d = 5.5, h = 3);      // head
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
    for (k = [1, 2]) translate([0, 0, GAP + DIE_LEN - k*NUT_T])                               // two nuts locked together
        cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);
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
    color("Silver")           spring(lift);
    color("DarkGray")         back_screws();
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
if (PART == "spacer")     spacer();
if (PART == "sol_frame")  sol_frame();
if (PART == "sol_coil")   sol_coil();
if (PART == "plunger")    plunger();
if (PART == "spring")     spring();
if (PART == "back_screws") back_screws();
if (PART == "standoff")   standoff();
if (PART == "nut")        nut();
if (PART == "stylus")     stylus();
if (PART == "die_screw")  die_screw();
if (PART == "die_nuts")   die_nuts();
if (PART == "paper")      paper();

echo(str("frame length ", SOL_LEN, ": stylus out ", STYLUS_OUT, " mm, top plate ", SOL_TOP,
         ", ledges ", LEDGE_TOP, ", lips from ", LIP_Z0, ", boss gap ", BOSS_BOT - SOL_TOP,
         ", tail room to bench ", LEDGE_TOP - (BASE_TOP - BASE_T),
         ", lock nut to skin at full stroke ", -SKIN - (SOL_TOP + SO_LEN + STROKE + NUT_T),
         ", lip gap at the wall ", LIP_Z0 - SOL_TOP));
