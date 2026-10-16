# Braille punch test rig v3

Bench rig for one braille dot: one JF-0826B solenoid, one steel stylus, one metal die.

- **Stylus:** an M3 × 16 dog-point set screw, filed to a dome. It is locked in an M3 × 18 hex standoff that replaces the acorn nut on the push rod. The standoff rides in a 5.8 mm hex bore just under the paper.
- **Die:** the hex socket of an M3 × 25 set screw, socket end down, threaded into the arm. The solenoid's acorn nut, glued on top, is the height knob: one turn moves the die 0.5 mm.

The solenoid sits under the paper and pushes up, so dots come out facing up. One C-frame holds the solenoid, the table and the die, so the strike force stays inside the frame.

## Files

| File | What |
| --- | --- |
| `cad/punch_rig_v3_003.scad` | The model. Solenoid dimensions are at the top; **check them against a real solenoid before printing.** Earlier iterations are in `cad/iterations/`. |
| `print/*.scad` | One wrapper per printed part, in print orientation |
| `print/*.stl` | Exported parts (validated watertight) |
| `print/rig_v3_plate.3mf` | PrusaSlicer project for a Prusa Core One plate: frame + table 5.8 + M3 arm + shims, PETG, 4 perimeters, 25 % gyroid, no supports. 77.4 g, about 3 h |
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

## Before printing, measure

- M3 holes on the 22 mm face: 6.5 mm and 21 mm from the push-rod end, 12 mm apart. These are the v2 datasheet numbers, unverified.
- Plunger axis to the M3 face: 12.5 mm. Up to ±1.5 mm off is fine, because the table boss can move in the deck.
- Standoff across flats: 5.5 mm. Brass standoffs are often 5.0 mm; for those, set `HEX_AF = 5.3`.
- Plunger tail and spring below the frame at rest: 20 mm or less.
- Anything raised on the push-rod face of the frame (a bushing or collar): 2 mm or less, or it hits the guide boss.

If a number is off, change it at the top of `cad/punch_rig_v3_003.scad` and re-export before printing. The moving parts were swept through the full 10 mm stroke against every printed part with no contact. That check holds only for these dimensions.

## Hardware

- JF-0826B 12 V push-pull solenoid
- M3 × 18 female-female hex standoff, 5.5 mm across flats (aluminium or steel)
- 2 or 3 M3 × 16 dog-point set screws (styli), one M3 × 25 set screw (die), 2 M3 nuts
- Screws: 2 × M3 × 6 socket head, 4 × M3 × 6 button head, 2 × M3 × 16 socket head with washers
- An M3 tap, and threadlocker or CA glue for the acorn-nut knob
- Electronics: a logic-level MOSFET (IRLB8721 or IRLZ44N), a 1N4007 diode, 100 Ω and 10 kΩ resistors, a 1000 µF 25 V capacitor, a breadboard, and a **12 V supply rated 3 A or more**
- Tools: calipers, a fine file or whetstone, 1.5 and 2.5 mm hex keys, a 5.5 mm wrench

## Assembly order

1. On the bench, screw the standoff onto the push rod, screw in a filed stylus with about 6 mm sticking out, and run the lock nut down onto the standoff.
2. Slide the printed table's boss down over the stylus, nut and standoff. If it stops at the nut, turn the nut until its flats line up with the standoff's, then lock it. The table has to pass over that nut every time it goes on. If the standoff binds, print `table_hex6.0`.
3. Take the table off. Slide the solenoid into the frame from the front, push rod up; the stylus passes through the slot in the deck. Screw it to the spine from the back.
4. Put the table back on and fit its screws loosely. Push the plunger up by its tail and move the table until the stylus slides freely, then tighten.
5. Fit the arm loosely. Fire once on scrap paper and move the arm until the mark lands in the die socket, then tighten. Set dot height with the knob.

## Holding the paper

Nothing clamps the paper yet. For single test dots, keep the strip's edge on the fence and clip it to the table's front or back edge with a small binder clip; the table is 4 mm thick. After each strike, make sure the strip has dropped back onto the table before you slide it, so the new dot doesn't drag under the die.
