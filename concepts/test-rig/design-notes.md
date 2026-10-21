# Test rig design notes

The test rig embosses one braille dot at a time with one solenoid. We need its answers before we design the full embosser. Is the solenoid strong enough? Which settings work? How fast can one stylus go?

This page explains:
- what the rig tests
- what each printed part is for
- the numbers the design assumes, and how we will check each one
- what the rig can't tell us

To build the rig, follow the [build guide](build-guide.md). To run the tests, use the [test plan](test-plan.md).

## What the rig tests

1. **Force.** Can a $3 solenoid at 12 V emboss a readable dot in 65 lb cardstock? Addison asked us to support that paper, because schools can buy it anywhere.
2. **Settings.** Which pulse length and die height give the best dot on each kind of paper?
3. **Speed.** How many dots per second can one stylus make? The answer helps us choose between our two designs. Design A has one stylus that moves across the page. Design B has six styli that strike a whole braille cell at once.
4. **Wear.** Do the stylus, the die and the plastic parts hold up over hundreds of strikes?

## How the rig works

![Cutaway of the rig at the top of a strike. The plunger has risen, and the stylus pushes the paper up into the die.](media/strike.gif)

- The solenoid stands under the paper with its push rod up. When it switches on, the plunger rises 10 mm.
- The stylus, a steel pin, rides on top of the plunger. It pushes the paper up into the die, a small hex socket in a steel screw. The paper takes the socket's shape and forms a dot.
- When the solenoid switches off, its spring and gravity pull the plunger back down.

Three choices shape the design:
- **The stylus pushes up from below.** The dot comes out facing up, so you can feel it without turning the paper over. The paper also lies flat on the table, and the plunger falls back by itself.
- **The stylus and die are steel.** Printed plastic dies crumble after a few dots. The BrailleRAP project found this, and Addison warned us about it.
- **We copy BrailleRAP's metal parts.** The stylus is the filed tip of a set screw. The die is the socket of another set screw. The plastic only holds them in place.
- **One frame holds everything.** Each strike pushes the die up and the solenoid down. The frame wraps around from the solenoid to the die, so it carries both forces. They cancel inside the frame instead of shaking the bench.

## What each printed part is for

| Part | What it does | Why it looks this way |
| --- | --- | --- |
| Frame | Holds the solenoid, the table and the die arm | The solenoid sits on two ledges, which take each strike. Two screws through the back wall go into the solenoid's own threaded holes. Two small lips above it stop it from jumping if those screws are out. It prints upright with no supports. |
| Table, two versions | Holds the paper flat and guides the stylus. Tick marks every 2.5 mm and 6.0 mm show dot and cell spacing. | A hex tube under the table keeps the standoff from turning and the stylus on the die. Printers make small holes slightly off size, so we print a tight fit (5.8) and a loose fit (6.0). |
| Die arm | Holds the die over the paper. Two nuts locked together on top of the die screw turn it, 0.5 mm per turn. | The die screw threads through a nut in a slot. The arm's screw holes are bigger than the screws, so it slides about 1 mm to line the die up with the stylus. An M4 version, for thick cardstock, is in `print/`. |
| Fence shims | Move the paper exactly 2.5, 5 or 10 mm from the fence | That is one dot, two dots or one line of braille, for spacing tests. |
| Stroke spacer | Sets the plunger's stroke back to 10 mm | The standoff replaces the solenoid's acorn nut, which used to stop the plunger at rest. See step 3 of the build guide. |

## The numbers the design assumes

| What we assume | Where it comes from | How we will know |
| --- | --- | --- |
| The solenoid frame is 22 x 25 x 27 mm, with an M3 push rod. | The seller's dimension drawing | It slides into the frame. |
| The solenoid's two threaded holes are where the drawing shows them. | The seller's dimension drawing | Two of the four slots in the back wall line up with them. |
| The plunger moves 10 mm and pushes hardest near the end of its stroke. | The seller's listing, and how solenoids work | We set the stylus to reach the paper in the last part of the stroke. |
| 12 V and 2 A push hard enough to emboss 65 lb cardstock. | BrailleRAP uses the same kind of 12 V, 2 A solenoid. Sellers rate it at about 20 N. | Test 1. If it can't, we try longer pulses, a 24 V solenoid or a lever. |
| The paper is about 0.25 mm thick. | 65 lb cover stock is about 0.23 mm. | We measure each paper. Raising or lowering the die covers the rest. |
| A good dot is about 0.5 mm high and 1.5 mm across. | The Library of Congress braille specification, [Specification 800](https://www.brailleauthority.org/node/63), calls for 0.48 mm high and 1.44 mm across. | We measure test dots, and Addison reads them. |
| Dots are 2.5 mm apart, cells 6.0 mm, and lines 10 mm. | Addison's message | The table's tick marks and the shims |
| The socket of an M3 set screw, 1.5 mm across, makes the right dot size. | BrailleRAP | Test dots. If they're too small, we try the M4 die. |
| The standoff is 5.5 mm across its flat sides and threaded all the way through. | What we ordered | The table fit check |
| The plastic is stiff enough. | The steel parts take the impact, and the plastic parts are 3 to 10 mm thick. | Test 6: the dot height stays the same over 500 strikes. |
| The coil stays cool enough for the PLA frame. | The code limits pulses to 100 ms and keeps the coil off at least 3 times as long as it was on. PLA starts to soften at about 55 °C. | Test 5. For long runs, reprint the frame in PETG. |
| Moving the paper by hand is accurate to about 0.3 mm. | Our estimate | Good enough to judge dots. Not good enough to test exact spacing. |

### Solenoid sizes from the seller's drawing

| Feature | Size |
| --- | --- |
| Frame | 22 mm wide, 25 mm deep, 27 mm long |
| Push rod | 3 mm across, with an M3 thread and an acorn nut. The nut's tip is 10 mm from the frame at rest. |
| Plunger end | 7.5 mm across, with a 2.5 mm cross hole. It sticks out 20 mm at rest: 11 mm of spring, then 9 mm of slotted end. |
| Mounting holes | Two M3 holes, 12 mm apart across the frame and 14.5 mm apart along it |
| Overall length at rest | 55 mm |

### Check these on the real parts

- **Frame length.** The stylus length in step 2 of the build guide depends on it. For a 27 mm frame, the stylus sticks out 7.0 mm above the standoff. Use 8 mm for a 26 mm frame, or 9 mm for 25 mm.
- **The lips.** They leave room for a solenoid frame up to about 27.3 mm long.
- **The push rod's thread.** The stroke spacer sets the stroke whatever the thread length. A very long rod could still reach the stylus inside the standoff.
- **The hex fit.** This depends on our printer. It is why there are two tables.
- **The mounting holes.** The two screws in the back wall are the main hold. The slots give 1 mm of room up and down and 0.5 mm side to side.

## What we checked in the 3D model

- The parts fit together, and nothing collides through the whole stroke. We checked solenoids 25, 26 and 27 mm long.
- The back-wall screws pass through their slots into the solenoid's holes.
- With a 27 mm solenoid, the stylus's lock nut stays 2.2 mm clear of the table at the top of the stroke.
- Every part prints without supports. A layer-by-layer check, `tools/print_check.py`, finds none of these:
  - material over thin air
  - a bridge longer than 12 mm, or one that ends in mid-air
  - anything thinner than one 0.4 mm line
- The same check confirms the plate's G-code has the right walls and a brim.

## What the rig can't test

- Moving the stylus across the page, or feeding the paper. The next step, a motorized cart, will.
- Six styli striking at once.
- A whole page, or months of use.
- Tactile graphics, which need the stylus placed anywhere on the page.

## Changes in version 014

- The slots in the back wall match our solenoid's threaded holes, measured with calipers. The holes are 13.8 mm apart along the solenoid and 11.5 mm across, not 14.5 and 12 as in the drawing. The hole nearer the push rod is 7.3 mm from that end of the frame. Our solenoid is 26.6 mm long, so its stylus sticks out about 7.4 mm.

## Changes in version 013

- The two front table nuts slide in from the slot in the middle of the deck, not from the front of the frame. Their slots used to run 14 mm to the front face. PrusaSlicer warned of floating bridge anchors over those long slots, because the bridge lines turn over empty space. Now every nut slot is about 5 mm long.

## Changes in version 012

- The table screws are socket head screws, which have 3 mm tall heads. The table is 4.5 mm thick instead of 3, so the heads sink below the paper. The deck sits 1.5 mm lower to match. The paper, stylus and die stay where they were.
- The table screw holes are deep enough for M3 x 8 or M3 x 10 screws.
- The plate prints on the Balanced profile with 3 perimeters, 4 top and 4 bottom layers and 15% gyroid infill, plus the brim. That takes about 3 hours instead of 4. The stronger settings in version 008 didn't fix any slicer warning, and the rig's forces are small.

## Changes in version 011

- No screw cuts its own thread in the plastic any more. The die screw threads through an M3 nut held in a slot in the arm's round end. Each strike pushes the nut up against 3 mm of arm above it.
- The table screws go into four M3 nuts held in slots just under the deck. The front two slots open on the front of the frame and the back two on the back, clear of the tower.
- The table screws are now M3 x 8, long enough to pass through the nuts.
- The side walls are 4 mm thick instead of 3, so they stay solid outside the nut slots.
- The blocks under the deck along the side walls start 3 mm lower, so the front nuts sit in solid plastic.

## Changes in version 010

- The arm screws go into captive M3 nuts instead of cutting their own thread in the tower. Threads cut in PLA wear out when the arm comes off and goes back on. The nuts slide into two slots in the tower's outer face.
- The arm screws are now M3 x 20, long enough to pass all the way through the nuts.
- The ceiling of each nut slot is a stepped bridge around the screw hole, like the table's counterbores.

## Changes in version 009

- The gusset under the tower's platform is solid across its full width, so nothing bridges under it. The old one left a 16 mm bridge, and PrusaSlicer flags PLA bridges past 16 mm.
- A slope under the deck behind the boss slot means no part of the deck bridges.
- The brim now prints. Earlier plates set a brim width but left the brim turned off.

## Changes in version 008

- The deck has a slope under it along each side wall. The deck beside the boss slot now prints on the slope instead of hanging over the solenoid pocket. The back end of the slot is square, so the deck behind it bridges straight across.
- Each table counterbore has a stepped bridge over it, so no bridge line hangs into the screw hole. The screw holes are 4.2 mm wide, so the table moves about 0.6 mm each way to line up.
- The plate prints with 4 perimeters, 5 top and 5 bottom layers and 25% gyroid infill, on the Structural profile.

## Changes in version 007

- Two screws through the back wall, into the solenoid's own threaded holes, now hold the solenoid. The jack screws, the zip ties and the zip-tie slots are gone.
- The deck is whole again, because nothing under it needs a tool.
- The lips above the solenoid are small fixed stops.
- The slots in the back wall are 4 mm wide, for 0.5 mm of room side to side.
- The fence shims print as three separate pieces.
- No glue: two nuts locked together replace the glued knob on the die screw, and the standoff needs no thread locker.
- There is no fit coupon. The sizes come from the seller's drawing, and the pocket has 0.5 mm of room on each side.

Older versions are in [`cad/iterations/`](cad/iterations/).
