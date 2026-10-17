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
| Coupon | Checks that the solenoid fits | It is a slice of the frame around the solenoid's ledges. It prints in 11 minutes, so a bad fit costs minutes, not a 3-hour print. |
| Frame | Holds the solenoid, the table and the die arm | The solenoid sits on two ledges, which take each strike. Two jack screws hold it down, and zip ties hold it against the back wall. It fits solenoids 25 to 28 mm long, in case a batch differs from the drawing. It prints upright with no supports. |
| Table, two versions | Holds the paper flat and guides the stylus. Tick marks every 2.5 mm and 6.0 mm show dot and cell spacing. | A hex tube under the table keeps the standoff from turning and the stylus on the die. Printers make small holes slightly off size, so we print a tight fit (5.8) and a loose fit (6.0). |
| Die arm | Holds the die over the paper. The knob on top moves the die 0.5 mm per turn. | Its screw holes are bigger than the screws, so it slides about 1 mm to line the die up with the stylus. An M4 version, with a 2.0 mm socket for thick cardstock, is in `print/`. |
| Fence shims | Move the paper exactly 2.5, 5 or 10 mm from the fence | That is one dot, two dots or one line of braille, for spacing tests. |
| Stroke spacer | Sets the plunger's stroke back to 10 mm | The standoff replaces the solenoid's acorn nut, which used to stop the plunger at rest. See step 3 of the build guide. |

## The numbers the design assumes

| What we assume | Where it comes from | How we will know |
| --- | --- | --- |
| The solenoid frame is 22 x 25 x 27 mm, with an M3 push rod. | The seller's dimension drawing | The coupon print |
| The plunger moves 10 mm and pushes hardest near the end of its stroke. | The seller's listing, and how solenoids work | We set the stylus to reach the paper in the last part of the stroke. |
| 12 V and 2 A push hard enough to emboss 65 lb cardstock. | BrailleRAP uses the same kind of 12 V, 2 A solenoid. Sellers rate it at about 20 N. | Test 1. If it can't, we try longer pulses, a 24 V solenoid or a lever. |
| The paper is about 0.25 mm thick. | 65 lb cover stock is about 0.23 mm. | We measure each paper. The knob adjusts for the rest. |
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

- **Frame length.** The stylus length in step 2 of the build guide depends on it. For a 27 mm frame, the stylus sticks out 7.0 mm above the standoff. Use 6 mm for 28 mm, 8 mm for 26 mm, or 9 mm for 25 mm.
- **The push rod's thread.** The stroke spacer sets the stroke whatever the thread length. A very long rod could still reach the stylus inside the standoff.
- **The hex fit.** This depends on our printer. It is why there are two tables.
- **The mounting holes.** The slots in the back wall follow the drawing. Use them only if they line up.

## What we checked in the 3D model

- The parts fit together, and nothing collides through the whole stroke. We checked solenoids 25, 27 and 28 mm long.
- A 2.5 mm hex key reaches the jack screws from above.
- With a 27 mm solenoid, the stylus's lock nut stays 2.2 mm clear of the table at the top of the stroke.
- Every part prints without supports, and every print file passes a geometry check.

## What the rig can't test

- Moving the stylus across the page, or feeding the paper. The next step, a motorized cart, will.
- Six styli striking at once.
- A whole page, or months of use.
- Tactile graphics, which need the stylus placed anywhere on the page.

## Changes in version 006

- The deck now stops short of the jack screws, so a hex key reaches them from above. In version 005, they sat under the deck with 12 mm of room above them. A standard 2.5 mm key needs about 18 mm.
- The jack screws moved 0.75 mm inward, so their heads clear the side walls.
- The table screws moved behind the deck's new front edge.
- The table is 1.2 mm thick around the stylus hole, down from 1.6 mm, which gives the stylus's lock nut more room.
- The holes in the back wall now match the seller's drawing, and they are slots.
- The stroke spacer is new.
- The tables and the arm have their size marked underneath.

Older versions are in [`cad/iterations/`](cad/iterations/).
