# Measurements for the case

Most of the case comes straight from the A1200KBv2 KiCad and STL files. These are the few numbers that can't, and each one maps to a parameter in `a1200kb-case.scad`. Measure on a finished keyboard (plates, switches, keycaps, shield and light pipes fitted), in mm. Photos with a ruler in shot go in `case/photos/`.

Positions are in the KBv2 PCB's KiCad coordinates: x to the right, y towards the front, origin at the KiCad origin. The PCB's rear-left corner is at (39.92, 29.93). Easier in practice: measure from the PCB's rear-left corner and add those numbers.

## Keyboard stack

| # | What | Parameter | Current guess | Measured |
|---|------|-----------|---------------|----------|
| 1 | PCB top to plate top | `plate_h` | 5.0 | |
| 2 | Plate top to top of a normal keycap at rest (e.g. `G`) | `key_h` | 14 | |
| 3 | Plate top to top of the light pipe shield or pipes, whichever is higher | `led_pocket` depth | 0 (pocket 1.2 into the lid) | |
| 4 | Lowest point under the PCB away from the brackets (solder, FFC connector) | bar clearance check | 2 | |

## Brackets

Only if the brackets are fitted. The case posts stop this far short of the PCB.

| # | What | Parameter | From STL | Measured |
|---|------|-----------|----------|----------|
| 5 | Left/right bracket, PCB underside to bracket underside at the screw holes | `side_bracket_t` | 3.4 | |
| 6 | Lower bracket, same | `lower_bracket_t` | 3.8 | |

## Light pipes

Where the light comes out, for the lid windows. The model assumes straight above each LED.

| # | Pipe | Parameter | Assumed x, y | Measured x, y | Face w × h |
|---|------|-----------|--------------|---------------|------------|
| 7 | power | `leds[0]` | 467.3, 58.3 | | |
| 8 | floppy | `leds[1]` | 467.23, 50.32 | | |
| 9 | disk | `leds[2]` | 467.19, 42.31 | | |

## DB37 socket

On the adapter, or a loose socket.

| # | What | Parameter | Current | Measured |
|---|------|-----------|---------|----------|
| 10 | Board edge to the front face of the flange | `db_flange_t` | 1.0 | |
| 11 | D shell outside: top width, bottom width, height | `db_cut` (add 0.5 clearance) | 56.8, 53.8, 9.0 | |
| 12 | PCB top to the centre of the D | `db_ch` | 6.25 | |
| 13 | Jackscrew thread in the flange (4-40 insert, plain hole, rivet) | hardware | | |
