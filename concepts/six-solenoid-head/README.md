# Six-solenoid head

This is a design for a head that embosses a whole braille cell in one strike. Nobody has built or tested it.

How it works:
1. Six solenoids stand in a ring.
2. Each solenoid pulls down the outer end of a lever.
3. The levers pivot near the middle, so their inner ends lift six steel pins.
4. The pins push the paper up into a metal die with six pockets.

The pins sit 2.5 mm apart, in 2 columns of 3. A solenoid is 22 mm wide, so it can't sit right under its own pin. The levers solve that.

| Number | Value |
| --- | --- |
| Lever ratio | About 3 to 1 (arms of 38 mm and 12 mm) |
| Pin stroke | 3.2 mm, from the solenoid's 10 mm stroke |
| Pin force | About 3 times the solenoid's force, minus friction |
| Head size | About 145 mm across |
| Peak current | 12 A when all six fire at once (2 A each, at 12 V) |

## Files

| File | What it is |
| --- | --- |
| `cad/six_head_002.scad` | The 3D model, in OpenSCAD. `PART` picks which part to show. `FIRED` picks which pins are up in the picture. |
| `cad/six_head_002.png` | The head striking the letter d (dots 1, 4 and 5). |
| `cad/six_head_002_top.png` | The levers seen from above, with the table hidden. |
| `viewer/index.html` | A 3D animation. Type a word and watch the head emboss it. Open it in a web browser. |
| `cad/iterations/` | The first version. Its levers would hit the solenoids when fired. Version 2 fixes that. |

We checked every lever, pin and plunger through its full swing in the 3D model. Nothing collides.

## Open questions

- The six pockets in the die must line up with the six pins to about 0.1 mm. That needs a drilled steel block.
- We haven't checked pivot friction or how much the levers bend.
- Six solenoids make a heavy head, about 145 mm wide, and all of it moves with the carriage.
- Pictures print at one-pin speed. Six pins only speed up text.
