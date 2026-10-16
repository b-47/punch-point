# Braille punch test rig

This rig embosses one braille dot at a time. We use it to test dots before we build the full embosser.

A solenoid under the paper pushes a steel stylus up through the paper into a metal die:
- **Stylus:** an M3 x 16 dog-point set screw with its tip filed round. A nut locks it into an M3 x 18 hex standoff. The standoff screws onto the solenoid's push rod in place of the acorn nut.
- **Die:** the hex socket in the end of an M3 x 25 set screw. The screw threads into the arm above the paper. The solenoid's acorn nut, glued on top, is the height knob. One turn moves the die 0.5 mm.

One printed frame holds the solenoid, the paper table and the die. The force of each strike stays inside the frame.

## Files

| File | What it is |
| --- | --- |
| `cad/punch_rig_005.scad` | The 3D model, in OpenSCAD. Older versions are in `cad/iterations/`. |
| `print/*.stl` | The printed parts, as STL files (the usual 3D-print format). |
| `print/*.scad` | One small file per printed part. Open one in OpenSCAD and export it to remake that STL. |
| `print/coupon.3mf` | A small test print of the solenoid pocket: 3.4 g, 11 minutes. Print it first. |
| `print/rig_plate.3mf` | All the printed parts on one plate for a Prusa Core One: 47 g of PETG plastic, about 2 hours 20 minutes, no supports. |
| `firmware/punch_test/` | Code for the ESP32 board that fires the solenoid. |
| `viewer/index.html` | A 3D animation of one strike. Open it in a web browser. |

## Before you print

You don't need to measure anything. The rig fits any JF-0826B-style solenoid that matches these:
- The frame is 22 mm wide and 25 mm deep. The pocket is 23 mm wide.
- The frame is 25 to 28 mm long. A shorter frame sits lower, so its stylus sticks out further. That's 6 mm for a 28 mm frame, and up to 9 mm for a 25 mm frame.
- The plunger sticks out no more than 31 mm below the frame. There is 33 mm of room.
- The plunger's center is 11 to 14 mm from the back of the frame.
- Any collar on the push-rod end sticks out 2 mm or less.
- The standoff is 5.5 mm across its flat sides. Brass standoffs are often 5.0 mm. For those, change `HEX_AF` to 5.3 in the model.

We checked the 3D model with 25, 27 and 28 mm solenoids. Nothing touches through the full stroke, and the solenoid slides in with the stylus already fitted.

The back wall has four screw holes for the solenoid's own threads. You don't need them. Use them only if they line up.

## What to buy

Parts:
- A JF-0826B solenoid, 12 V
- An M3 x 18 hex standoff, threaded inside at both ends, 5.5 mm across the flats
- 2 or 3 M3 x 16 dog-point set screws, for styli
- An M3 x 25 set screw, for the die
- 2 M3 nuts
- 2 M3 x 12 screws, to hold the solenoid down
- 4 M3 x 6 button-head screws, to hold the table
- 2 M3 x 16 socket-head screws and 2 washers, to hold the arm
- 2 zip ties, up to 4 mm wide and at least 150 mm long
- An M3 tap
- Super glue or thread locker, for the knob

Electronics:
- A logic-level MOSFET (an electronic switch): IRLB8721 or IRLZ44N
- A 1N4007 diode
- A 100 Ω resistor and a 10 kΩ resistor
- A 1000 µF capacitor rated for 25 V
- A breadboard and jumper wires
- A 12 V power supply rated for 3 A or more

Tools: calipers, a fine file, 1.5 mm and 2.5 mm hex keys, and a 5.5 mm wrench.

## Put it together

### Check the fit
1. Print the coupon.
2. Slide the bottom of the solenoid into the coupon. It should slide between the walls without forcing.
3. Check that it sits flat on the ledges, and that the plunger and spring clear them.

### Fit the stylus
1. Unscrew the acorn nut from the solenoid's push rod. Keep it for the knob.
2. Screw the standoff onto the push rod as far as it goes.
3. File the tip of a dog-point set screw into a smooth dome.
4. Screw it into the top of the standoff, with about 7 mm sticking out.
5. Screw a nut down onto the standoff to lock it.
6. Slide the tube under the printed table down over the stylus, nut and standoff.
7. If the tube stops at the nut, turn the nut until its flat sides line up with the standoff's. Then tighten the nut.
8. If the standoff sticks in the tube, print `table_hex6.0` and use that table instead.
9. Take the table off again.

### Fit the solenoid
1. Slide the solenoid into the frame from the front, push rod up, until it touches the back wall.
2. Turn the two screws above the solenoid down onto its top until they are snug. Use a hex key from the front.
3. Thread a zip tie through each pair of slots at the front of the frame, across the solenoid, and around the back. Pull it tight.
4. Push the plunger up as far as it goes. You can reach it through the window in the back.
5. Measure from the top of the frame's deck to the tip of the stylus. It should be about 4.3 mm.
6. Screw the stylus in or out until it is. Keep the nut's flat sides in line with the standoff's.

### Fit the table
1. Put the table on, with its screws loose.
2. Push the plunger up again.
3. Move the table until the stylus slides freely, then tighten the screws.

### Fit the die
1. Tap an M3 thread through the hole in the arm.
2. Screw the M3 x 25 set screw in from the top, socket end first, until about 0.6 mm sticks out underneath.
3. Screw a nut down onto the top of the arm.
4. Glue the acorn nut onto the top of the screw.
5. Fit the arm, with its screws loose.
6. Put scrap paper on the table and fire the solenoid once.
7. Move the arm until the mark lands in the die socket. Then tighten the screws.
8. Turn the knob until a test dot forms cleanly. Then tighten the nut under the knob.

## Hold the paper

Nothing clamps the paper yet.
1. Put the edge of the paper strip against the fence, the raised wall beside the table.
2. Clip the strip to the front or back edge of the table with a small binder clip.
3. After each strike, check that the paper has dropped back onto the table before you slide it. Otherwise the new dot drags under the die.

## Fire the solenoid

The code runs on an ESP32 board. Pin 4 drives solenoid 1, and pin 13 drives solenoid 2.

1. In VS Code, install the pioarduino IDE extension. Install it or PlatformIO IDE, not both.
2. Open the folder `firmware/punch_test`.
3. In the status bar, pick `esp32dev` for most ESP32 boards, or `esp32-s3` for ESP32-S3 boards.
4. Plug in the board and click Upload. The first time, this downloads several GB of tools.
5. Open the Serial Monitor.
6. Type a command and press Enter.

| Command | What it does |
| --- | --- |
| `f 25` | Fires one 25 ms pulse. |
| `f 25 2` | Fires one 25 ms pulse on solenoid 2. |
| `r 20 25 500` | Fires 20 pulses of 25 ms, one every 500 ms. |
| `w 5 40 5` | Each press of the BOOT button fires the next pulse length: 5 ms, then 10, up to 40. |
| `s` | Stops a run. |

The code never fires a pulse longer than 100 ms. It also keeps each solenoid off for at least 3 times as long as it was on, so the coil can't overheat.

To move to a newer ESP32 toolkit, change the release number in the `platform` line of `platformio.ini`.

## Remake the print files

If you change the model, export each part again. Open its file in `print/` with OpenSCAD and export it, or run:

```
openscad -o print/frame.stl print/frame.scad
```
