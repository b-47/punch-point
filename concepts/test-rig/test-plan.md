# Test plan for the punch test rig

These tests find out whether one $3 solenoid can emboss good braille dots, with which settings, and how fast. Run them in order, because each one uses the settings found by the one before. Record every result in a copy of [`test-log.csv`](test-log.csv). It opens in any spreadsheet program.

The tests:
1. First dot
2. Pulse length
3. Paper types
4. Speed
5. Heat
6. Wear
7. Reading test
8. Second solenoid

The [design notes](design-notes.md) explain why each test matters.

## Before each session

1. Write down the date, who is testing, and which solenoid, table and die you are using.
2. Check that the arm screws, the table screws and the nut under the knob are tight.
3. Unplug the 12 V adapter whenever your fingers are near the stylus or the die.

## How to judge a dot

- **Height.** Close the calipers on flat paper next to the dot and set them to zero. Then close them gently over the dot. The reading is the dot's height. Measure 3 dots and write down the average. The target is about 0.5 mm.
- **Feel.** Rate each dot from 1 to 5. 1 means you can't feel it, 3 means it is readable, and 5 means it is as crisp as a dot from a Perkins brailler. A braille reader's rating counts most.
- **Damage.** Write down whether the top of the dot is torn or cracked.
- **Photo.** Take a photo of each test strip next to a ruler, and write the photo's file name in the log.

## The tests

### 1. First dot

Find a die height that makes a good dot. Every later test starts from it.
1. Use 65 lb cardstock and 25 ms pulses.
2. Fire with `f 25`. If there is no dot, turn the knob a quarter turn clockwise and fire on fresh paper.
3. Stop at the first setting that makes a full, round dot without tearing.
4. Write down how many turns the knob is from where the die first touches the paper.

### 2. Pulse length

Find the shortest pulse that makes a full dot. Shorter pulses are faster and keep the coil cooler.
1. Type `w 5 40 5`. Now each press of the button labeled BOOT on the ESP32 fires the next pulse length. The lengths are 5 ms, 10 ms, and so on up to 40 ms.
2. Press BOOT, then slide the paper along the fence to the next 6 mm tick mark. Repeat until the sweep finishes.
3. Judge each of the 8 dots.
4. Write down the shortest pulse that gives a full dot. This is the working pulse.

### 3. Paper types

Find which papers work, and the best settings for each. Repeat tests 1 and 2 on each paper:
- 20 lb copy paper, for comparison
- 65 lb cardstock
- 80 lb braille paper from the American Printing House, from Addison
- 100 lb cardstock, from Addison

Addison offered to send samples of the last two. Ask him before you reach this test.

### 4. Speed

Find how many dots per second one stylus can make.
1. Type `r 20 <working pulse> 500`. For example, `r 20 25 500` fires 20 pulses of 25 ms, one every 500 ms.
2. While it fires, pull the paper slowly along the fence, so each strike lands on fresh paper.
3. Check that every dot is full.
4. Repeat with a shorter gap between pulses: 300 ms, 200 ms, 150 ms and 100 ms.
5. Write down the shortest gap that still gives 20 full dots. Dots per second is 1000 divided by that gap in milliseconds.

The code keeps the coil off for at least 3 times as long as each pulse. With 25 ms pulses, it won't fire faster than once every 100 ms, or 10 times a second.

### 5. Heat

Check that the coil stays cool enough at full speed.
1. Type `r 200 <working pulse> <shortest gap from test 4>`, and pull the paper through as before.
2. When it finishes, measure the coil's temperature with an infrared or probe thermometer. Don't touch the coil, because it may be hot.
3. Stop and slow down if the coil is above 70 °C. That limit is our own margin, not a number from the seller.

### 6. Wear

Check that nothing drifts or wears over many strikes.
1. Fire 500 strikes at the working pulse, pulling paper through.
2. Measure the height of dot 1 and of dot 500.
3. Look at the stylus tip and the die socket with a magnifying glass.
4. Look at the frame for cracks or white stress marks, and check for loose screws.

### 7. Reading test

Check that a braille reader can read the dots.
1. Emboss a short word. Slide the paper along the tick marks for the columns of a cell, 2.5 mm apart, and for the next cell, 6 mm along. Use the fence shims for the rows.
2. Ask Addison or another braille reader to read it, and to rate the dots.

### 8. Second solenoid

Repeat test 2 with solenoid 2, to see whether two solenoids of the same kind behave the same.

## Later tests

These need parts we don't have yet:
- **M4 die:** a bigger socket, 2.0 mm across, for thick cardstock. It needs the M4 arm in `print/`, an M4 set screw, nut and acorn nut, and an M4 tap.
- **Groove die:** file a groove 1.5 mm wide across the end of a spare set screw. This shows whether a fixed bar with a groove could replace a moving die in the full machine.
- **Perkins die:** the die from a Perkins brailler costs $8.95 from Perkins. It needs its own arm, which we can design once we can measure one.
- **24 V solenoid:** a 24 V version of the same solenoid, run at 20 V from a USB-C charger.

## What the results decide

| If the tests show | Then |
| --- | --- |
| Full dots in 65 lb cardstock at 12 V | The solenoid is strong enough, and the 12 V power plan stands. |
| No full dot even at 100 ms | We need more force: a 24 V solenoid, a lever like the one in the six-solenoid head, or a bigger solenoid. The power plan changes too. |
| Paper tears before the dots are full | Try a rounder stylus tip, the M4 die, or thinner paper. |
| 5 or more dots per second | One stylus may be fast enough, which favors design A. |
| Under 3 dots per second | Six styli become more attractive, which favors design B. |
| Dot height drops over 500 strikes | The frame needs to be stiffer, or something is coming loose. |

To estimate the time to emboss a page, divide the dots on the page by the dots per second. For example:
- A full 8.5 x 11 page holds about 25 lines of 30 to 32 cells.
- We estimate such a page of text has about 2,000 dots.
- At 5 dots per second, the striking alone takes about 7 minutes.
- Moving the stylus and the paper adds time on top of that.

## Recording results

Each row of [`test-log.csv`](test-log.csv) is one test strip or one run. The columns:

| Column | What to write |
| --- | --- |
| `date` | The day, such as 2026-10-21 |
| `tester` | Your name |
| `test` | The test number, 1 to 8 |
| `solenoid` | 1 or 2 |
| `table` | 5.8 or 6.0 |
| `die` | M3 or M4 |
| `paper` | For example, 65 lb cardstock |
| `knob_turns` | Turns from where the die first touches the paper |
| `pulse_ms` | Pulse length in milliseconds |
| `gap_ms` | Time from one pulse to the next, for runs |
| `strikes` | How many pulses |
| `dot_height_mm` | The average of 3 dots |
| `feel_1_to_5` | Your rating |
| `torn` | yes or no |
| `photo` | The photo's file name |
| `notes` | Anything else |

The code also prints a line for every pulse, such as `pulse,12,1,25`: pulse number 12, solenoid 1, 25 ms. You can paste these lines into a spreadsheet to keep an exact record of a run.
