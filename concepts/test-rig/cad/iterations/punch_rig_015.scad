// Punch Point braille punch test rig, version 015
//
// One JF-0826B-class solenoid, one steel stylus, one metal die.
// Solenoid sizes come from the seller's dimension drawing (22 x 25 x 27 mm frame,
// M3 push rod, M3 holes 12 x 14.5 mm apart, plunger tail 20 mm at rest).
// Die and pin, from plain M3 socket head screws and nuts (version 015):
//   moving die = an M3 x 16 socket head screw, head up, riding on the push rod. The 2.5 mm
//            hex socket in its head shapes the dot. A stop nut on the push rod sets the
//            stroke, and a joining nut couples rod and screw, which butt end to end
//   fixed pin  = an M3 x 20 socket head screw, tip sanded round, pointing down through a
//            captive nut in the arm; set from the top with a hex key, locked by a nut
// The paper is pressed down into the socket, so dots face down. (Versions up to 014 used
// a dog-point stylus in a hex standoff and a set-screw die.)
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
                    // back_screws | arm_screws | table_screws | die_screw | die_nuts | paper
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
SOL_HOLE_X   = 5.75;       // the solenoid's M3 holes, measured on the real part: 11.5 mm apart across the back face
SOL_HOLE_Z   = [7.7, 21.5]; // and 13.8 apart along it: 7.3 and 21.1 from the push-rod end of a 26.6 mm frame,
                           // given here from the top of the drawing's 27 mm frame
SLOT_TRAVEL  = 1;          // spine slots run +/-1 mm along z, since the ledges set the height
SLOT_W       = 4.0;        // and are 4 mm wide: +/-0.5 mm across for an M3 screw

// ---------- stylus stack ----------
SO_AF      = 5.5;   // standoff across flats
SO_LEN     = 18;
ROD_IN     = 15.9;  // push rod past the top plate with the plunger pushed fully in, measured
DIE_L      = 16;    // M3 x 16 socket head screw: the moving die
PIN_L      = 20;    // M3 x 20 socket head screw: the fixed pin
HEAD_D     = 5.5;   // M3 socket head
HEAD_H     = 3;
HEAD_SOCKET = 2.5;  // its hex socket, across flats
WASHER     = [9, 3.4, 1.0];   // printed washers for the arm screws: outside, hole, thickness
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
DIE_M   = 3;        // die set screw: M3, or M4 for thick cardstock
SOCKET_AF = 1.5;    // M3 set-screw socket (M4 is 2.0)

// ---------- printed geometry ----------
HEX_AF      = 5.8;  // guide bore; 5.7 to 6.0 depending on fit
NUT_BORE    = 6.9;  // round bore above the hex, where the lock nut travels
STYLUS_HOLE = 6.2;  // the moving die's 5.5 mm screw head rises through the skin to the paper
SKIN        = 1.2;  // table skin round the die hole
TABLE_T     = 4.5;  // thick enough to sink an M3 socket head below the paper
DECK_T      = 3;
WALL        = 4;  // 4 so the table nut channels leave 1.6 mm outside them
SPINE_T     = 4;
SIDE_CLR    = 0.5;  // 23 mm pocket for a 22 mm frame
BOSS_D      = 11;
FENCE_X     = 20;   // fence to punch axis
TOWER_X2    = 32;
TOWER_Y     = 11;   // tower and fence run y -11 .. 11
ARM_Z0      = 5;
ARM_T       = 10;
ARM_W       = 18;
ARM_SCREW_L = 20;   // M3 x 20 socket heads with printed washers, into captive nuts in the tower
NUT_CLR     = 0.3;  // nut slot: across flats and height over the nut's own
NUT_CEIL    = -1.4; // nut slot ceiling: 6.4 mm of tower above it takes the screw's pull
NOSE_D      = 8;
DIE_NUT_TOP = 3;    // arm above the die's captive nut: takes the strike and the lock nut's pull
TABLE_SCREW_L = 8;  // M3 x 8 socket heads; the holes also take M3 x 10
SIDE_DROP   = 4;    // the side slopes start 3 mm under the deck, so the table nuts sit in solid plastic
BASE_T      = 4;
CB_DEPTH    = 3.2;  // counterbore for M3 socket heads (3 mm tall)
CB_D        = 7.4;  // a 5.5 mm head with room to move +/-0.6 mm with the table
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
TNUT_CEIL   = DECK_BOT + 1;   // table nut slots: ceiling 1 mm up into the deck, 2 mm of deck over it
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

// A captive nut's slot, flats facing y, from the hole's axis out along +x for `len`. Its ceiling
// is at z = 0, where the nut bears; `up` raises it, for bridge_steps. SUBTRACTIVE.
module nut_slot(af, t, len, up = 0) hull() for (x = [0, len])
    translate([x, 0, -t - NUT_CLR - 0.1]) cylinder(d = hexd(af + NUT_CLR), h = t + NUT_CLR + 0.1 + up, $fn = 6);
// The slot, with its ceiling stepped round a `hole` that carries on up through it. The slot
// opens at its outer end, so the ceiling bridges across it. SUBTRACTIVE.
module captive_nut(af, t, hole, len) {
    nut_slot(af, t, len);
    rotate([0, 0, 90]) bridge_steps(hole) rotate([0, 0, -90]) nut_slot(af, t, len, up = 1);
}

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
            // wing under the tower, on a 45 degree gusset across its full width: no bridge under it
            translate([SIDE_OUT - 0.01, -TOWER_Y, DECK_BOT]) cube([WING + 0.01, 2*TOWER_Y, DECK_T]);
            hull() {
                translate([SIDE_OUT - 0.01, -TOWER_Y, DECK_BOT - WING]) cube([0.01, 2*TOWER_Y, WING]);
                translate([SIDE_OUT, -TOWER_Y, DECK_BOT - 0.01]) cube([WING, 2*TOWER_Y, 0.01]);
            }
            // a slope under the deck behind the boss slot, from the back wall to the slot's back edge
            yz_extrude([[FACE_Y + 0.01, DECK_BOT + 0.01], [FACE_Y + 0.01, DECK_BOT - (FACE_Y - SLOT_BACK)*tan(DECK_SLOPE)],
                        [SLOT_BACK, DECK_BOT + 0.01]], -SIDE_IN - 0.01, 2*SIDE_IN + 0.02);
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
                // a block under the deck along each side wall, out to the boss slot, so the deck
                // beside the slot prints on it instead of hanging over the solenoid pocket. It holds
                // the front table nuts; its underside slopes up to the wall
                mirror([s < 0 ? 1 : 0, 0, 0])
                    xz_extrude([[SIDE_IN + 0.01, DECK_BOT + 0.01],
                                [SIDE_IN + 0.01, DECK_BOT - SIDE_DROP - (SIDE_IN - SLOT_HALF)*tan(DECK_SLOPE)],
                                [SLOT_HALF, DECK_BOT - SIDE_DROP], [SLOT_HALF, DECK_BOT + 0.01]],
                               FRONT_Y, FACE_Y - FRONT_Y);
            }
        }
        // slot for the guide boss, open to the front: the solenoid slides in with its stylus
        // already fitted. Square at the back, so the deck behind it bridges straight across
        translate([-SLOT_HALF, FRONT_Y - 1, DECK_BOT - 1]) cube([2*SLOT_HALF, SLOT_BACK - FRONT_Y + 1, DECK_T + 2]);
        // table screws: clearance holes down through captive M3 nuts. The front nuts slide in
        // from the boss slot and the back ones from the back face, clear of the wing. Every
        // slot is short: PrusaSlicer flags the bridge over a long one (floating bridge anchors)
        for (p = TABLE_SCREWS) translate([p[0], p[1], 0]) {
            translate([0, 0, TNUT_CEIL - 8]) cylinder(d = 3.4, h = DECK_TOP - TNUT_CEIL + 9);
            translate([0, 0, TNUT_CEIL]) rotate([0, 0, table_nut_dir(p)])
                captive_nut(NUT_AF, NUT_T, 3.4, p[1] < SLOT_BACK ? abs(p[0]) - SLOT_HALF + 1 : SPINE_Y2 + 1 - p[1]);
        }
        // arm screws: clearance holes down through captive M3 nuts, which slide in from the
        // tower's outer face. Flats face y, so a nut seats on the slot's pointed end, centred
        // under its hole. The slot is open at the outer face, so its ceiling bridges across y,
        // stepped round the screw hole
        for (p = ARM_SCREWS) translate([p[0], p[1], 0]) {
            translate([0, 0, NUT_CEIL - 8.6]) cylinder(d = 3.4, h = ARM_Z0 - NUT_CEIL + 9.6);
            translate([0, 0, NUT_CEIL]) captive_nut(NUT_AF, NUT_T, 3.4, TOWER_X2 + 1 - p[0]);
        }
        // slots for the two M3 x 6 screws into the solenoid's own threaded holes; both
        // diagonals, since the drawing shows one pair but not which way round it will face
        for (x = [-SOL_HOLE_X, SOL_HOLE_X], hz = SOL_HOLE_Z)
            hull() for (dz = [-SLOT_TRAVEL, SLOT_TRAVEL])
                translate([x, FACE_Y - 1, FRAME_TOP - hz + dz]) rotate([-90, 0, 0]) cylinder(d = SLOT_W, h = SPINE_T + 2);
        // side windows: wires out, plastic saved; walls stay solid where the ledges, lips and gussets attach
        yz_extrude(arch(-9, 9, BASE_TOP + 4, LEDGE_TOP - 3.5), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
        yz_extrude(arch(-9, 9, LEDGE_TOP + 2, LIP_Z0 - 1.6), -SIDE_OUT - 1, 2*SIDE_OUT + 2);
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
// M3 or M4 nut sizes for the die
function die_nut_af(m) = m == 4 ? 7 : NUT_AF;
function die_nut_t(m)  = m == 4 ? 3.2 : NUT_T;
function die_nut_floor(m) = ARM_Z0 + ARM_T - DIE_NUT_TOP - die_nut_t(m) - NUT_CLR - 0.1;
module arm(m = DIE_M) {
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
        // die hole: clearance through a captive nut, which slides in from the round end. The
        // strike pushes the nut up into the arm. The arm prints top face down, so the slot's
        // floor is the bridge, stepped round the hole
        translate([0, 0, NOSE_Z - 1]) cylinder(d = m + 0.4, h = ARM_Z0 + ARM_T - NOSE_Z + 2);
        translate([0, 0, die_nut_floor(m)]) rotate([0, 0, 180]) mirror([0, 0, 1])
            captive_nut(die_nut_af(m), die_nut_t(m), m + 0.4, ARM_W/2 + 1);
        // oversize holes: slide the arm +/-1.1 mm to centre the socket on the stylus
        for (p = ARM_SCREWS) translate([p[0], p[1], ARM_Z0 - 1]) cylinder(d = 5.2, h = ARM_T + 2);
        // die size underneath
        under_label(str("M", m), [12.5, 0], ARM_Z0);
    }
}

// ================================================================ fence shims
// Lay one against the fence to move the paper 2.5 / 5 / 10 mm (one dot row,
// two dot rows, one braille line) away from it.
SHIMS = [2.5, 5, 10];
module washers() for (k = [0:2]) translate([k*12, 0, 0]) difference() {          // three, one spare
    cylinder(d = WASHER[0], h = WASHER[2]); translate([0, 0, -1]) cylinder(d = WASHER[1], h = WASHER[2] + 2); }
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
    translate([0, 0, face]) cylinder(d = 3, h = SOL_TOP + ROD_IN - STROKE - face);   // push rod through the pole
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
// The moving die and the nuts on the push rod. Names kept from the standoff layout, for the viewer.
function rod_top(lift) = SOL_TOP + ROD_IN - STROKE + lift;
module hexnut() difference() { cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6); translate([0, 0, -1]) cylinder(d = 2.5, h = NUT_T + 2); }
module standoff(lift = 0) translate([0, 0, SOL_TOP + lift]) hexnut();            // stop nut: sits on the top plate at rest
module nut(lift = 0) translate([0, 0, rod_top(lift) - NUT_T/2]) hexnut();        // joining nut: half on the rod, half on the die screw
module stylus(lift = 0) translate([0, 0, rod_top(lift)]) difference() {          // moving die: M3 x 16, head up
    union() { cylinder(d = 3, h = DIE_L); translate([0, 0, DIE_L]) cylinder(d = HEAD_D, h = HEAD_H); }
    translate([0, 0, DIE_L + HEAD_H - 1.5]) cylinder(d = hexd(HEAD_SOCKET), h = 2, $fn = 6);
}
function die_top(lift) = rod_top(lift) + DIE_L + HEAD_H;
PIN_TIP = die_top(STROKE) + PAPER - DOT_H;   // the pin presses the paper DOT_H into the socket
module die_screw() translate([0, 0, PIN_TIP]) {                                 // fixed pin: M3 x 20, tip sanded round
    hull() { translate([0, 0, 1]) cylinder(d = 3, h = 0.01); translate([0, 0, 1]) sphere(r = 1); translate([0, 0, 1.5]) cylinder(d = 3, h = 0.01); }
    translate([0, 0, 1.5]) cylinder(d = 3, h = PIN_L - 1.5);
    translate([0, 0, PIN_L]) cylinder(d = HEAD_D, h = HEAD_H);
}
module die_nuts() {
    top = ARM_Z0 + ARM_T;
    translate([0, 0, top]) cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);                    // lock nut
    translate([0, 0, top - DIE_NUT_TOP - NUT_T]) cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);  // captive nut
}
// Which way each table nut's slot runs: front ones in toward the boss slot, back ones out the back
function table_nut_dir(p) = p[1] < SLOT_BACK ? (p[0] > 0 ? 180 : 0) : 90;
// M3 x 8 socket heads through the table into captive nuts under the deck
module table_screws() for (p = TABLE_SCREWS) translate([p[0], p[1], 0]) {
    translate([0, 0, -CB_DEPTH - TABLE_SCREW_L]) cylinder(d = 3, h = TABLE_SCREW_L);
    translate([0, 0, -CB_DEPTH]) cylinder(d = 5.5, h = 3);
    translate([0, 0, TNUT_CEIL - NUT_T]) rotate([0, 0, table_nut_dir(p)]) difference() {
        cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 2.5, h = NUT_T + 2);
    }
}
// M3 x 20 socket head screws and washers through the arm into the captive nuts
module arm_screws() for (p = ARM_SCREWS) translate([p[0], p[1], 0]) {
    top = ARM_Z0 + ARM_T;
    translate([0, 0, top + WASHER[2] - ARM_SCREW_L]) cylinder(d = 3, h = ARM_SCREW_L);  // shank
    translate([0, 0, top]) cylinder(d = WASHER[0], h = WASHER[2]);                 // printed washer
    translate([0, 0, top + WASHER[2]]) cylinder(d = 5.5, h = 3);                   // head
    translate([0, 0, NUT_CEIL - NUT_T]) difference() {                            // captive nut
        cylinder(d = hexd(NUT_AF), h = NUT_T, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 2.5, h = NUT_T + 2);
    }
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
    color("DarkGray")         arm_screws();
    color("DarkGray")         table_screws();
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
if (PART == "washers")    washers();
if (PART == "spacer")     spacer();
if (PART == "sol_frame")  sol_frame();
if (PART == "sol_coil")   sol_coil();
if (PART == "plunger")    plunger();
if (PART == "spring")     spring();
if (PART == "back_screws") back_screws();
if (PART == "arm_screws") arm_screws();
if (PART == "table_screws") table_screws();
if (PART == "standoff")   standoff();
if (PART == "nut")        nut();
if (PART == "stylus")     stylus();
if (PART == "die_screw")  die_screw();
if (PART == "die_nuts")   die_nuts();
if (PART == "paper")      paper();

echo(str("frame length ", SOL_LEN, ": ledges ", LEDGE_TOP, ", die head top at rest ", die_top(0), ", at full stroke ", die_top(STROKE),
         ", pin tip ", PIN_TIP, ", nose ", NOSE_Z, ", joining nut top at full stroke ", rod_top(STROKE) + NUT_T/2,
         " (hex tube ends ", SO_TOP_REST, "), arm screw past its nut ", (NUT_CEIL - NUT_T) - (ARM_Z0 + ARM_T + WASHER[2] - ARM_SCREW_L),
         ", table screw past its nut ", (TNUT_CEIL - NUT_T) - (-CB_DEPTH - TABLE_SCREW_L)));
