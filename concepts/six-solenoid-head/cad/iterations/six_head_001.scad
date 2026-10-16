// Punch Point: six-solenoid braille head, concept sketch
//
// One whole braille cell per strike. Six JF-0826B solenoids stand on a ring and
// pull the outer ends of six levers down. The levers pivot near the middle, so
// their short inner arms lift six steel pins (2 x 3 grid, 2.5 mm pitch) up
// through the paper table into a six-pocket metal die. The lever ratio turns the
// solenoid's 10 mm stroke into a ~3 mm pin stroke at about 3x the force.
// Dot-matrix printer heads solve the same problem the same way: fat actuators
// on a ring, thin levers or wires converging on a tight grid of pins.
//
// A concept to look at, not a tested or print-ready design.
//
// Coordinates (mm): cell centre at x 0, y 0; z 0 = top of the paper table.
// x runs along a line of braille, y up the page. Dots 1-2-3 are the left
// column top to bottom, 4-5-6 the right column.

PART  = "assembly";          // assembly | top | frame | table | bridge | die
                             // sol_frame | sol_coil | plunger | lever | pin | paper
FIRED = [1, 0, 0, 1, 1, 0];  // dots struck in the assembly view: "d" is 1-4-5
$fn = 40;

PITCH  = 2.5;   // dot spacing inside a cell
PIN_D  = 1.5;
STROKE = 10;    // solenoid stroke
L2 = 12;        // pivot to pin (short arm)
L1 = 38;        // pivot to solenoid link (long arm)
PIN_STROKE = STROKE * L2 / L1;
PHI_MAX  = asin(STROKE / L1);
TIP_FULL = 1.25;                    // pin tip at the end of the stroke, as on the test rig
TIP_REST = TIP_FULL - PIN_STROKE;
PIN_LEN  = 16;
LEVER_T  = 3;
LEVER_W  = 4;
TIP_W    = 1.6;
Z_LEVER  = TIP_REST - PIN_LEN;      // lever tops at rest; the pins stand on them
Z_AXLE   = Z_LEVER - LEVER_T / 2;

SOL_LEN = 27; SOL_W = 22; SOL_D = 25;
LINK_GAP  = 8;
Z_SOL_TOP = Z_LEVER - LEVER_T - LINK_GAP;
Z_BASE    = Z_SOL_TOP - SOL_LEN - 14;
Z_HUB_TOP = Z_LEVER - LEVER_T - 3;
Z_BOSS    = Z_LEVER + 4.5;          // bottom of the pin guide, clear of the rising lever tips
TABLE_T   = 4;

// dot -> [x, y, direction its lever runs out to]
DOTS = [[-PITCH/2,  PITCH, 120], [-PITCH/2, 0, 180], [-PITCH/2, -PITCH, 240],
        [ PITCH/2,  PITCH,  60], [ PITCH/2, 0,   0], [ PITCH/2, -PITCH, 300]];
function u(i)     = [cos(DOTS[i][2]), sin(DOTS[i][2])];
function pin(i)   = [DOTS[i][0], DOTS[i][1]];
function pivot(i) = pin(i) + L2 * u(i);
function link(i)  = pin(i) + (L2 + L1) * u(i);

// ---------------------------------------------------------------- moving parts (local frames)
// Lever: pivot axis along Y through the origin, long arm out along +X.
module lever() {
    difference() {
        union() {
            hull() {
                translate([-L2, 0, -LEVER_T/2]) cylinder(d = TIP_W, h = LEVER_T);
                translate([-2, -LEVER_W/2, -LEVER_T/2]) cube([4, LEVER_W, LEVER_T]);
            }
            translate([0, -LEVER_W/2, -LEVER_T/2]) cube([L1 + 3, LEVER_W, LEVER_T]);
        }
        rotate([90, 0, 0]) cylinder(d = 2, h = LEVER_W + 2, center = true);
        hull() for (dx = [-0.7, 1.4])   // slot: the link moves straight down while the lever end swings
            translate([L1 + dx, 0, 0]) rotate([90, 0, 0]) cylinder(d = 2, h = LEVER_W + 2, center = true);
    }
}

// Pin: bottom at z 0, standing on its lever.
module pin_part() {
    cylinder(d = 2.4, h = 1);
    cylinder(d = PIN_D, h = PIN_LEN - PIN_D/2);
    translate([0, 0, PIN_LEN - PIN_D/2]) sphere(d = PIN_D);
}

// Solenoid: top (slotted plunger end) at z 0, depth along +X.
module sol_frame() {
    difference() {
        translate([-SOL_D/2, -SOL_W/2, -SOL_LEN]) cube([SOL_D, SOL_W, SOL_LEN]);
        translate([-SOL_D/2 - 1, -SOL_W/2 + 1.5, -SOL_LEN + 1.5]) cube([SOL_D + 2, SOL_W - 3, SOL_LEN - 3]);
        translate([0, 0, -SOL_LEN - 1]) cylinder(d = 8, h = SOL_LEN + 2);
    }
}
module sol_coil() {
    translate([0, 0, -SOL_LEN + 1.5]) difference() {
        cylinder(d = 20, h = SOL_LEN - 3);
        translate([0, 0, -1]) cylinder(d = 8, h = SOL_LEN);
    }
}

// Plunger with the fork that grips the lever end; z 0 = solenoid top, at rest.
module plunger() {
    translate([0, 0, -12]) cylinder(d = 7, h = 12 + LINK_GAP - 2);
    for (y = [LEVER_W/2 + 0.4, -LEVER_W/2 - 0.4 - 1.4]) translate([-2, y, LINK_GAP - 2]) cube([4, 1.4, LEVER_T + 3]);
    translate([0, 0, LINK_GAP + LEVER_T/2]) rotate([90, 0, 0]) cylinder(d = 1.8, h = LEVER_W + 3.6, center = true);
}

// ---------------------------------------------------------------- fixed parts (world frame)
module frame() {
    translate([0, 0, Z_BASE - 5]) cylinder(r = 72, h = 5, $fn = 96);
    for (i = [0:5]) translate([link(i)[0], link(i)[1], Z_BASE]) difference() {   // pedestals, hollow for the push rod
        cylinder(d = 18, h = Z_SOL_TOP - SOL_LEN - Z_BASE);
        translate([0, 0, -1]) cylinder(d = 8, h = 30);
    }
    translate([0, 0, Z_BASE]) cylinder(d = 38, h = Z_HUB_TOP - Z_BASE, $fn = 6);   // hub
    for (i = [0:5]) translate([pivot(i)[0], pivot(i)[1], 0]) rotate([0, 0, DOTS[i][2]]) {   // pivot forks
        for (y = [LEVER_W/2 + 0.3, -LEVER_W/2 - 0.3 - 2]) translate([-2, y, Z_HUB_TOP]) cube([4, 2, Z_AXLE - Z_HUB_TOP + 2]);
        translate([0, 0, Z_AXLE]) rotate([90, 0, 0]) cylinder(d = 1.9, h = LEVER_W + 5.2, center = true);
    }
    for (x = [-58, 58], y = [-42, 42]) translate([x, y, Z_BASE]) cylinder(d = 8, h = -TABLE_T - Z_BASE);
}

module table() {
    difference() {
        union() {
            translate([-66, -50, -TABLE_T]) cube([132, 100, TABLE_T]);
            translate([-5, -6.5, Z_BOSS]) cube([10, 13, -TABLE_T - Z_BOSS + 0.01]);   // pin guide
        }
        for (i = [0:5]) translate([pin(i)[0], pin(i)[1], Z_BOSS - 1]) cylinder(d = PIN_D + 0.2, h = 30);
    }
}

// Bridge over the paper that holds the die; the die block is steel.
module bridge() {
    for (y = [-46, 40]) translate([-4, y, 0]) cube([8, 6, 18]);
    translate([-4, -46, 12]) cube([8, 92, 6]);
    translate([-5, -6.5, 6]) cube([10, 13, 6.01]);
}
module die() {
    difference() {
        translate([-5, -6.5, 1]) cube([10, 13, 5]);
        for (i = [0:5]) translate([pin(i)[0], pin(i)[1], 1 - 0.01]) cylinder(d = PIN_D, h = 1.5);
    }
}

module paper() translate([-80, -15, 0]) cube([160, 30, 0.25]);

// ---------------------------------------------------------------- assembly
module mechanism(show_table = true) {
    color("SteelBlue") frame();
    if (show_table) {
        color("LightSteelBlue") table();
        color("SteelBlue") bridge();
        color("DarkSlateGray") die();
        color("White", 0.85) paper();
    }
    for (i = [0:5]) {
        phi = FIRED[i] ? PHI_MAX : 0;
        translate([link(i)[0], link(i)[1], Z_SOL_TOP]) rotate([0, 0, DOTS[i][2]]) {
            color("DimGray") sol_frame();
            color("Chocolate") sol_coil();
            color("Silver") translate([0, 0, -L1 * sin(phi)]) plunger();
        }
        color("Goldenrod") translate([pivot(i)[0], pivot(i)[1], Z_AXLE]) rotate([0, 0, DOTS[i][2]]) rotate([0, phi, 0]) lever();
        color("Gainsboro") translate([pin(i)[0], pin(i)[1], Z_LEVER + L2 * sin(phi)]) pin_part();
    }
}

if (PART == "assembly")  mechanism();
if (PART == "top")       mechanism(show_table = false);
if (PART == "frame")     frame();
if (PART == "table")     table();
if (PART == "bridge")    bridge();
if (PART == "die")       die();
if (PART == "sol_frame") sol_frame();
if (PART == "sol_coil")  sol_coil();
if (PART == "plunger")   plunger();
if (PART == "lever")     lever();
if (PART == "pin")       pin_part();
if (PART == "paper")     paper();

echo("GEOM", L1 = L1, L2 = L2, PHI_MAX = PHI_MAX, PIN_STROKE = PIN_STROKE, Z_LEVER = Z_LEVER,
     Z_AXLE = Z_AXLE, Z_SOL_TOP = Z_SOL_TOP, TIP_FULL = TIP_FULL, PITCH = PITCH);
echo("DOTS", DOTS);
