# Build the punch test rig

Printing takes about 2.5 hours, and assembly about an hour. After the build, run the [test plan](test-plan.md).

![The finished rig: a blue printed frame holds the solenoid upright, with a paper table on top and the arm over the paper.](media/build/9-finished.png)

## What you need

### Printed parts

Print in PLA. The files are in [`print/`](print/).

| File | What it holds | Plastic and time |
| --- | --- | --- |
| `rig_plate.3mf` | Every printed part, for a Prusa Core One | 52 g, 2.5 hours |
| `rig_plate_mk4.3mf` | Every printed part, for a Prusa MK4 | 52 g, 2.5 hours |
| `coupler_plate_coreone.3mf`, `coupler_plate_mk4.3mf` | Just the coupler table (marked 8.3), two couplers and two stop sleeves, if you printed the full plate before version 018 | 15 g, 31 minutes on the Core One at 0.28 mm |

Use the file for your printer. Both use 0.20 mm layers, 3 perimeters, 4 top and 4 bottom layers, 15% gyroid infill, a 5 mm brim and no supports. For another printer, use the STL files with the same settings.

### Hardware

Solenoid, die and pin:
- 1 JF-0826B solenoid, 12 V. A solenoid is an electromagnet with a steel rod inside, the plunger. The plunger jumps 10 mm when you switch the power on.
- The printed coupler. It screws onto the plunger's push rod by a captive nut, and the hole in its top is the die.
- 1 M3 x 20 socket head screw: the pin. It points down through the arm, and its tip presses the paper into the die.
- 3 M3 nuts: the captive nut in the coupler, the captive nut in the arm, and a lock nut on top of the arm.

Frame:
- 2 M3 x 6 socket head screws. They go through the back wall into the solenoid's own threaded holes.
- 4 M3 x 8 socket head screws and 4 M3 nuts, for the table. M3 x 10 also works.
- 2 M3 x 20 socket head screws and 2 M3 nuts, for the arm, with the 2 printed washers.

Electronics:
- 1 ESP32 board and a USB cable that carries data. The ESP32 is a small board you can program.
- 1 logic-level MOSFET, an electronic switch: IRLB8721 or IRLZ44N.
- 1 1N4007 diode.
- 1 100 ohm resistor and 1 10k ohm resistor.
- 1 1000 µF (microfarad) capacitor, rated for 25 V or more.
- 1 sealed 12 V wall adapter, rated 3 A or more, with a 5.5 x 2.1 mm barrel plug. Use a sealed adapter, not an open-frame power supply with bare terminals.
- 1 barrel jack to screw terminal adapter.
- A breadboard and jumper wires.

### Tools

- Calipers.
- A 2.5 mm hex key. One with a ball end helps.
- Small pliers or a 5.5 mm wrench, to hold nuts.
- Tweezers, to place two of the nuts.
- Sandpaper or a diamond nail file, to round the pin's tip. Optional, but the dots come out cleaner.

## 1. Print the parts

1. Print the rig plate.
2. Peel off the brim. Check that every screw hole is clear.

## 2. Round the pin

![The pin: an M3 x 20 socket head screw with its tip rounded.](media/build/1-pin.png)

1. Take the M3 x 20 screw. If you can, round its tip: rub it on sandpaper or a diamond nail file, rolling the screw as you go, until the end is a smooth dome. A sharp end tends to cut the paper instead of pressing it.
2. If you have nothing to round it with, skip this step.

## 3. Fit the coupler to the solenoid

![A 3.5 mm stop sleeve and the coupler, in orange, above the solenoid's push rod. The coupler's nut, in gold, slides into the slot in its side.](media/build/2-die-parts.png)

1. Unscrew the acorn nut and the black rubber washer from the push rod, the thin threaded rod on top of the solenoid. You won't need them. Hold the plunger while they're off, or it can slide out of the spring end.
2. Slide a 3.5 mm stop sleeve, the short printed tube, over the push rod and down onto the solenoid. It can sit on the small raised ring there.
3. Push an M3 nut flat into the slot in the side of the coupler, near its bottom, until it stops over the hole.
4. Screw the coupler onto the push rod, nut end down, until it stops. Only the last 4 mm or so of the rod is threaded.
5. Turn the coupler back 3 turns. The rod's tip is now about level with the top of the nut inside.
6. Push the plunger in and let it go. The coupler should move about 9 mm and land on the sleeve.

The hole in the top of the coupler is the die.

## 4. Fit the solenoid in the frame

![The top of the frame with the four table nuts, in orange, beside their slots: two at the back, and two inside the middle slot of the deck.](media/build/4-table-nuts.png)

1. Put the four table nuts in first, while the slot in the deck is empty. The deck is the flat top of the frame.
   - Two slots open on the back of the frame, just under the deck. Push an M3 nut into each with a hex key until it stops.
   - The other two open into the slot in the middle of the deck, one on each side, just under the deck. Hold an M3 nut flat with tweezers and set it in the mouth of one slot. It falls through if you let go early. Push it outward with a hex key until it stops.
![The solenoid, in orange, sliding into the frame from the front, push rod up.](media/build/5-slide-in.png)

2. Find the side of the solenoid with two threaded holes. It is one of its two flat steel sides.
3. Slide the solenoid in from the front, push rod up, with that side toward the back wall. The die screw ends up under the slot in the deck.
4. Push the solenoid back until it touches the back wall. Its bottom plate rests on two ledges inside the side walls.
5. Look through the four slots in the back wall. Two of them line up with the solenoid's holes.
6. Put an M3 x 6 socket head screw through each of those two slots. Tighten them with the 2.5 mm hex key. Use 6 mm screws, because longer ones can poke past the steel toward the coil.
7. Lead the solenoid's two wires out through a window in a side wall.

![The frame from behind. Two screws, in orange, go through two of the four slots in the back wall.](media/build/6-back-screws.png)

If no slot lines up with a hole, you can still run the first tests. Two small lips above the solenoid stop it from jumping, and the table holds it in place once it is on. Measure where the holes really are, so we can move the slots to match.

## 5. Fit the table

![The table and its four screws, in orange, lifted above the frame. The tube under it slides down over the parts on the push rod.](media/build/7-table.png)

1. Take the table marked 8.3 underneath, from the coupler plate. Turn the coupler so its flat sides line up with the hex tube under the table.
2. Lower it onto the deck, so the tube under it slides down over the coupler.
3. Put in the 4 M3 x 8 socket head screws, loosely. Their heads sink below the table surface.
4. Reach through the window in the back wall, under the solenoid, and push the plunger up as far as it goes.
5. The coupler's round top should rise to about level with the table surface, centered in the big hole.
6. Move the table until the plunger slides up and down freely.
7. Tighten the 4 screws.
8. Let go of the plunger. It should drop back by itself.

If the coupler sticks in the tube, loosen the table screws and shift the table until it slides freely.

## 6. Fit the arm and the pin

![The arm, in orange, lifted above the table, with the pin through its round end. Above it, the two arm screws, each with a printed washer under its head.](media/build/8-arm.png)

1. Push an M3 nut into the slot in the round end of the arm. Push it in flat until it stops under the hole.
2. Screw the M3 x 20 pin into the hole from the top, rounded tip first, so it threads down through the nut. Turn it with the 2.5 mm hex key in its head.
3. Stop when the tip is level with the lowest point of the arm, under the hole.
4. Screw an M3 nut onto the pin from the top, down to the arm. Leave it loose. Later it locks the pin's height.
5. Push an M3 nut into each of the two slots in the outer face of the tower, the block that rises beside the table. Push each nut in flat until it stops under its screw hole.
6. Slide a printed washer, one of the flat rings, onto each of two M3 x 20 screws, up against the head. The arm's screw holes are wider than a screw head, so without them the heads would sink into the plastic.
7. Put the arm on top of the tower. Fix it with those two screws, washers under the heads, but leave the screws loose.
8. Push the plunger up and hold it there.
9. Turn the pin clockwise, down, until its tip rests in the die hole in the top of the coupler.
10. Slide the arm until the tip sits centered in the hole.
11. Tighten the two arm screws. Then let go of the plunger.
12. Turn the pin one turn counterclockwise, to raise it 0.5 mm.

Turning the pin clockwise lowers it, and each turn moves it 0.5 mm.

## 7. First dot by hand, without the electronics

You can fire the solenoid without the circuit by touching its wires to a 12 V supply for a moment. The supply must give 12 V and at least 2 A. Any of these works:
- a 12 V adapter rated 2 A or more
- a universal adapter set to 12 V, rated 2 A or more at 12 V
- a bench power supply set to 12 V, with a 2.5 A current limit

Keep your fingers away from the pin and die while the supply is on.

1. With the supply unplugged, connect one solenoid wire to one side of the supply. On a barrel plug, the center is usually + and the outer metal is −. The solenoid works either way round.
   - Without a screw terminal adapter: fold the bare end of the wire over to make it thicker and push it into the plug's center hole. Wrap a bare spare wire tightly around the plug's outer metal. Tape the whole plug so the two can't touch.
2. If the supply has a voltage dial, set it to 12 V before you plug it in.
3. Lay a strip of 65 lb cardstock on the table, with its edge against the fence, the side of the tower that faces the table.
4. Plug in the supply. Fire by touching the free wire to the solenoid's other wire for less than half a second. The solenoid clicks once.
5. If there is no dot, turn the pin a quarter turn clockwise and fire again. If the paper tears, turn it back.
6. Stop when the dot is round and firm. Tighten the lock nut on top of the arm to hold the setting.

The dot forms on the underside of the paper, so turn the paper over to feel it.

Wait a few seconds between taps, and stop if the solenoid gets warm. Holding the wires together longer doesn't push harder, it only heats the coil. The settings, speed and wear tests in the test plan need the electronics, which time each pulse.

## 8. Wire the electronics

Unplug the 12 V adapter whenever you change a wire.

![Circuit diagram: the 12 V adapter powers the solenoid through the MOSFET. The diode sits across the solenoid, and the ESP32 switches the MOSFET. The steps below list every connection.](media/circuit.svg)

Make these connections on the breadboard:
1. Plug the 12 V adapter into the barrel jack adapter. Wire its + terminal to one breadboard rail, the +12 V rail. Wire its − terminal to the other rail, the ground rail.
2. Put the capacitor across the two rails. Its longer leg goes to +12 V. The side with the stripe goes to ground. A capacitor put in backwards can burst.
3. Put the MOSFET in the breadboard. With its label toward you and its legs down, the pins are gate, drain and source, from left to right.
4. Wire one solenoid wire to +12 V and the other to the MOSFET's drain. The solenoid's wires can go either way round.
5. Put the diode next to the solenoid: its striped end to +12 V, its other end to the MOSFET's drain. A diode put in backwards shorts the adapter the moment the solenoid fires.
6. Wire the MOSFET's source to ground.
7. Wire the 100 ohm resistor from the MOSFET's gate to the ESP32 pin labeled GPIO 4.
8. Wire the 10k ohm resistor from the MOSFET's gate to ground. It keeps the solenoid off while the ESP32 starts up.
9. Wire an ESP32 pin labeled GND, for ground, to the ground rail.

The ESP32 gets its power from the USB cable. Never connect 12 V to the ESP32.

For a second solenoid, build a second copy of the solenoid, diode, MOSFET and both resistors. Wire its 100 ohm resistor to the pin labeled GPIO 13.

## 9. Load the code

The code is in [`firmware/punch_test/`](firmware/punch_test/). It runs on most ESP32 boards and on ESP32-S3 boards.

1. In VS Code, install the pioarduino IDE extension. Install it or PlatformIO IDE, not both.
2. Open the folder `firmware/punch_test`.
3. In the status bar, pick `esp32dev` for most ESP32 boards, or `esp32-s3` for ESP32-S3 boards.
4. Plug in the board and click Upload. The first time, this downloads several gigabytes of tools.
5. Open the Serial Monitor.

To move to a newer ESP32 toolkit later, change the release number in the `platform` line of `platformio.ini`.

## 10. Fire the first dot with the electronics

Keep your fingers away from the pin and die while the 12 V adapter has power.

1. Plug in the 12 V adapter.
2. Lay a strip of 65 lb cardstock on the table, with its edge against the fence. The fence is the side of the tower that faces the table. A strip about 30 mm wide leaves the tick marks on the table in view.
3. In the Serial Monitor, type `f 25` and press Enter. The solenoid should click once.
4. Look at the underside of the paper. If there is no dot, turn the pin a quarter turn clockwise and fire again.
5. Stop when the dot is round and firm and the paper isn't torn.
6. Tighten the lock nut on top of the arm to hold the setting.

Commands:

| Command | What it does |
| --- | --- |
| `f 25` | Fires one 25 ms pulse. |
| `f 25 2` | Fires one 25 ms pulse on solenoid 2. |
| `r 20 25 500` | Fires 20 pulses of 25 ms, one every 500 ms. |
| `w 5 40 5` | Each press of the button labeled BOOT on the ESP32 fires the next pulse length: 5 ms, then 10, up to 40. |
| `s` | Stops a run. |

The code never fires a pulse longer than 100 ms. It also keeps each solenoid off for at least 3 times as long as it was on, so the coil can't overheat.

Now run the [test plan](test-plan.md).

## If something goes wrong

| What you see | What to do |
| --- | --- |
| Nothing happens when you fire. | Check that the adapter has power and the MOSFET pins are in the right order. Check the wire from the ESP32's ground to the ground rail. |
| The adapter cuts out when you fire. | Unplug it. The diode is probably in backwards. |
| The solenoid stays on. | Check the 10k ohm resistor from the gate to ground, and the MOSFET pins. |
| The plunger sticks partway up. | Loosen the table screws and move the table until the plunger slides freely.  |
| The die doesn't reach the paper. | Screw the coupler a turn further down onto the push rod (step 3), then lower the pin to match. |
| The paper drags under the pin. | Raise the pin. Loosen the lock nut on top of the arm, then turn the pin counterclockwise. |
| The paper tears. | Raise the pin, or round its tip more. |
| Dots are faint. | Lower the pin a quarter turn at a time, or use a longer pulse. |
| Dots get fainter during a session. | Tighten the lock nut on top of the arm, the arm screws and the two screws in the back wall. A worn die makes faint dots: fit the spare coupler. |

## Change the model

The model is [`cad/punch_rig_018.scad`](cad/punch_rig_018.scad), in OpenSCAD. After you change it:
1. Open each file in `print/` with OpenSCAD and export its STL, or run `openscad -o print/frame.stl print/frame.scad` for each part.
2. Slice the plate again.
3. Run `python3 tools/print_check.py` from the top of the repository. It must end with PRINT CHECK PASSED.
4. Run `python3 tools/build_rig_parts.py` to update the 3D viewer.
