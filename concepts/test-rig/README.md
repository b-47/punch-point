# Braille punch test rig

This rig embosses one braille dot at a time. We use it to test dots before we build the full embosser. A solenoid under the paper pushes a steel stylus up through the paper into a metal die.

![Cutaway of the rig: the plunger rises, and the stylus pushes the paper up into the die.](media/strike.gif)

- [Build guide](build-guide.md): print, buy, assemble, wire and fire the first dot.
- [Design notes](design-notes.md): what the rig tests, what each part is for, and the numbers the design assumes.
- [Test plan](test-plan.md): the tests to run, how to judge a dot, and what the results decide.
- [Parts and costs](https://b-47.github.io/punch-point/bom/): every part, with prices and links.
- [3D viewer](https://b-47.github.io/punch-point/concepts/test-rig/viewer/): watch one strike, and change the paper, die and stylus.

## Files

| File | What it is |
| --- | --- |
| `cad/punch_rig_006.scad` | The 3D model, in OpenSCAD. Older versions are in `cad/iterations/`. |
| `print/rig_plate.3mf` | All the printed parts on one plate for a Prusa Core One: about 59 g of PETG, a common 3D printing plastic. It takes about 2 hours 50 minutes, with no supports. |
| `print/coupon.3mf` | A small test print of the solenoid pocket: 3.4 g, 11 minutes. Print it first. |
| `print/*.stl` | Each printed part, as an STL file, the usual 3D printing format. |
| `print/*.scad` | One small file per printed part. Open one in OpenSCAD and export it to remake that STL. |
| `firmware/punch_test/` | Code for the ESP32, the small programmable board that fires the solenoid. |
| `media/circuit.svg` | The circuit diagram. `circuit.png` is the same diagram for slides. |
| `test-log.csv` | A blank sheet for test results. |
| `viewer/` | The 3D viewer. |
