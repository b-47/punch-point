# Braille punch test rig

Bench rig for one braille dot: one JF-0826B solenoid, one steel stylus, one metal die.

- **Stylus:** an M3 × 16 dog-point set screw, filed to a dome. It is locked in an M3 × 18 hex standoff that replaces the acorn nut on the push rod. The standoff rides in a 5.8 mm hex bore just under the paper.
- **Die:** the hex socket of an M3 × 25 set screw, socket end down, threaded into the arm. The solenoid's acorn nut, glued on top, is the height knob: one turn moves the die 0.5 mm.

The solenoid sits under the paper and pushes up, so dots come out facing up. One C-frame holds the solenoid, the table and the die, so the strike force stays inside the frame.

## Files

| File | What |
| --- | --- |
| `cad/punch_rig_v3_005.scad` | The model. The solenoid slots in without using its own screw holes: its bottom plate sits on ledges in the side walls, two jack screws in lips over the top plate hold it down, and zip ties across the front keep it in. Any frame length from 25 to 28 mm fits. Earlier iterations are in `cad/iterations/`. |
| `print/*.scad` | One wrapper per printed part, in print orientation |
| `print/*.stl` | Exported parts (validated watertight) |
| `print/coupon.3mf` | The solenoid pocket around the ledges, 3.4 g, 11 min. Print it first and check the solenoid fits. |
| `print/rig_v3_plate.3mf` | PrusaSlicer project for a Prusa Core One plate: frame + table 5.8 + M3 arm + shims. PETG, 0.2 mm layers, 3 perimeters, 4 top and bottom layers, 15 % gyroid, no supports. 47 g, about 2 h 20 min |
| `firmware/punch_test/punch_test.ino` | ESP32 sketch for one or two solenoids (GPIO 4 and 13). Fire set-length pulses over serial (`f 25`, `f 25 2`, `r 20 25 500`, `s`), or step through a pulse-length sweep with the BOOT button (`w 5 40 5`). Caps pulses at 100 ms and duty at 25 %. Builds for ESP32 and ESP32-S3 (Arduino core 3.3.12); not yet run on a board |
| `viewer/index.html` | Animated 3D cutaway and cross-section of a strike, with sliders for paper thickness, die height, die socket and stylus tip. Open it in a browser straight from the folder; it runs offline. `viewer/parts.js` holds the part meshes exported from the .scad; three.js r128 (MIT) is in `viewer/vendor/` |

To re-export after changing the model, open the wrapper in OpenSCAD and export it, or run:

```
openscad -o print/frame.stl print/frame.scad
```

## Flashing the ESP32

1. In VS Code, install the **pioarduino IDE** extension. It's a maintained fork of PlatformIO IDE, whose last release was January 2025. Install one or the other, not both.
2. Open the folder `firmware/punch_test`.
3. Pick the environment in the status bar: `esp32dev` for boards with an ESP32-WROOM-32 module, or `esp32-s3`.
4. Plug in the board, click Upload, then open the Serial Monitor. Type a command and press Enter.

`platformio.ini` uses pioarduino's ESP32 platform (Arduino core 3.3.12). PlatformIO's own ESP32 platform still ships core 2.0.17. To update, change the release number in the platform URL. The first build on a new computer downloads several GB of ESP32 tools.

## What the solenoid has to match

Nothing needs measuring before printing. The rig takes any JF-0826B-style solenoid that meets these:

- Frame 22 mm wide across the back face and 25 mm deep; the pocket is 23 mm wide. Every listing agrees on these two.
- Frame length along the plunger, 25 to 28 mm (listings say 26 or 27). A shorter body sits lower; its stylus screws further out of the standoff, 6 mm for a 28 mm body up to 9 mm for 25.
- Plunger tail no more than 31 mm below the frame at rest; there's 33 mm to the bench.
- Plunger axis about 12.5 mm from the back face. Up to ±1.5 mm off is fine, because the table boss can move in the deck.
- Anything raised on the push-rod face (a bushing or collar): no more than 2 mm with a 28 mm body, 5 mm with a 25 mm one.
- Standoff across flats: 5.5 mm. Brass standoffs are often 5.0 mm; for those, set `HEX_AF = 5.3`.

The M3 holes in the spine are optional. They only line up if the solenoid's own holes match the old v2 datasheet numbers.

The moving parts were swept through the full 10 mm stroke against every other part with 25, 27 and 28 mm bodies, and the solenoid was slid in from the front with its stylus fitted and a 31 mm tail, all with no contact.

## Hardware

- JF-0826B 12 V push-pull solenoid
- M3 × 18 female-female hex standoff, 5.5 mm across flats (aluminium or steel)
- 2 or 3 M3 × 16 dog-point set screws (styli), one M3 × 25 set screw (die), 2 M3 nuts
- Screws: 2 × M3 × 12 (jack screws over the solenoid), 4 × M3 × 6 button head (table), 2 × M3 × 16 socket head with washers (arm), and optionally 2 × M3 × 6 into the solenoid's own holes
- 2 zip ties up to 4 mm wide and at least 150 mm long
- An M3 tap, and threadlocker or CA glue for the acorn-nut knob
- Electronics: a logic-level MOSFET (IRLB8721 or IRLZ44N), a 1N4007 diode, 100 Ω and 10 kΩ resistors, a 1000 µF 25 V capacitor, a breadboard, and a **12 V supply rated 3 A or more**
- Tools: calipers, a fine file or whetstone, 1.5 and 2.5 mm hex keys, a 5.5 mm wrench

## Assembly order

1. Print the coupon. Slide the solenoid's bottom end into it: the frame should slide between the walls without forcing, sit flat on the ledges, and the plunger and spring should clear the ledges.
2. On the bench, screw the standoff onto the push rod, screw in a filed stylus with about 7 mm sticking out, and run the lock nut down onto the standoff.
3. Slide the printed table's boss down over the stylus, nut and standoff. If it stops at the nut, turn the nut until its flats line up with the standoff's, then lock it. The table has to pass over that nut every time it goes on. If the standoff binds, print `table_hex6.0`.
4. Take the table off. Slide the solenoid into the frame from the front, push rod up, until its back face meets the spine. Its bottom plate rides on the ledges, the stylus passes through the slot in the deck, and a long tail passes through the slot in the base.
5. Turn the two jack screws in the lips down onto the top plate's front corners until snug, using a hex key from the front. Thread a zip tie through each pair of slots at the front of the walls, across the solenoid's face and around the back of the frame, and pull it tight.
6. Push the plunger all the way up by its tail (through the window in the back) and measure from the top of the deck to the stylus tip: it should be about 4.3 mm, which puts the tip 1.25 mm above the table. Adjust the stylus in the standoff to get there, keeping the nut's flats in line with the standoff's.
7. Put the table on and fit its screws loosely. Push the plunger up again and move the table until the stylus slides freely, then tighten.
8. Fit the arm loosely. Fire once on scrap paper and move the arm until the mark lands in the die socket, then tighten. Set dot height with the knob.

## Holding the paper

Nothing clamps the paper yet. For single test dots, keep the strip's edge on the fence and clip it to the table's front or back edge with a small binder clip; the table is 3 mm thick. After each strike, make sure the strip has dropped back onto the table before you slide it, so the new dot doesn't drag under the die.
