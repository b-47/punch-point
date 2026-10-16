# Six-solenoid head (concept)

A sketch of a head that punches a whole braille cell per strike. It's for discussing the six-actuator idea, not a tested or print-ready design.

Six JF-0826B solenoids stand on a ring and pull the outer ends of six levers down. The levers pivot near the middle, so their short inner arms lift six steel pins up through the paper table into a six-pocket metal die. The pins sit in a 2 × 3 grid at 2.5 mm pitch. A solenoid is 22 mm wide, so it can't sit over its own pin; the levers carry each stroke in to the grid, the way dot-matrix printer heads do.

| Number | Value |
| --- | --- |
| Lever ratio | 38 : 12, about 3.2 : 1 |
| Pin stroke | 3.2 mm from the 10 mm solenoid stroke |
| Pin force | about 3 × the solenoid's, before pivot friction |
| Head size | about 145 mm across |
| Peak current | 12 A if all six fire at once (2 A each at 12 V) |

## Files

| File | What |
| --- | --- |
| `cad/six_head_002.scad` | The model. `PART` selects a part; `FIRED` sets which dots are struck in the assembly render. |
| `cad/six_head_002.png`, `cad/six_head_002_top.png` | Renders: the head striking "d" (dots 1-4-5), and the lever star from above with the table removed. |
| `viewer/index.html` | Animated 3D view: type a word and watch it emboss cell by cell, firing a cell's dots all at once or one after another, with the live current draw. Open it in a browser straight from the folder; it runs offline. |
| `cad/iterations/` | v001. Its lever ends sat 8 mm above the solenoids but drop 10 mm when fired, so they would hit the solenoid tops. v002 raises them to 14 mm. |

Every lever, pin and plunger was swept through its full swing against the frame, the table, every solenoid and each other, with no contact.

## Open questions

- The six-pocket die has to line up with six pins to about a tenth of a millimetre, and it's a drilled steel block, not set screws.
- Pivot friction and lever stiffness haven't been looked at.
- About 145 mm of head with six solenoids rides on the carriage.
- Pictures still run at one-pin speed; six pins only speed up text.
