# Braille punch test rig

This rig embosses one braille dot at a time.

![Cutaway of the rig: the plunger rises, and the stylus pushes the paper up into the die.](media/strike.gif)

- [Build guide](build-guide.md)
- [Design notes](design-notes.md)
- [Test plan](test-plan.md)
- [3D viewer](https://b-47.github.io/punch-point/concepts/test-rig/viewer/)

## Files

| File | What it is |
| --- | --- |
| `cad/punch_rig_020.scad` | The 3D model, in OpenSCAD. Older versions are in `cad/iterations/`. |
| `print/filament_plate_mk4.3mf` | The die arm, coupler table, one coupler and a stop sleeve on one plate for a Prusa MK4: about 11 g of PLA and 40 minutes. `filament_plate_coreone.3mf` is the same plate for a Core One. |
| `print/*.stl` | Each printed part. |
| `print/*.scad` | One file per printed part, to export its STL. |
| `firmware/punch_test/` | Code for the ESP32 that fires the solenoid. |
| `media/circuit.svg` | The circuit diagram. `circuit.png` is the same diagram for slides. |
| `test-log.csv` | A blank sheet for test results. |
| `viewer/` | The 3D viewer. |
