# A1200 standard keyboard socket (DIN 5)

A small board for A1200s with the CN17 "KB TEST" header: it gives the A1200 a standard Amiga 5-pin DIN keyboard socket, the same as an A2000 or A3000. No firmware.

- An A2000 or A3000 keyboard plugs straight in.
- An A4000 keyboard (6-pin mini-DIN) works through a standard passive PS/2-to-AT adapter; the pinouts line up the same way as on a PC.
- The A1200KBv2 plugs in through the [`encoder`](../encoder/Readme.md).
- An A1200 keyboard works through an Amiga keyboard controller board (see setup D in the [setup guide](../docs/Readme.md)).

```
A1200 CN17 ── [din5 board] ── DIN 5 socket ── any Amiga keyboard
```

## CN17

CN17 brings out the onboard keyboard controller's serial lines. The A1200 schematic marks it "new on Rev 1E PCB": check your board for a 7-pin header near the keyboard ribbon connector. On some boards the pads are there but the header isn't fitted.

| CN17 pin | Signal |
|----------|--------|
| 1 | KB_DATA |
| 2 | KB_CLOCK |
| 3 | KB_RESET |
| 4 | Reset input of U13, the A1200's keyboard controller |
| 5 | NC |
| 6 | VCC |
| 7 | GND |

No CN17 on your board? A PLCC clip on U13 can bring the same signals out on a CN17-order header; the [setup guide](../docs/Readme.md#no-cn17-clip-onto-u13) has the pin mapping.

JP1 (bridged) ties CN17 pin 4 to ground so the A1200's own keyboard controller (U13) stays in reset and lets go of the clock and data lines. Cut JP1 to give it back.

## DIN 5 pinout

Female socket, front view: 3 and 1 across, 5 and 4 on the diagonals, 2 at the bottom.

| Pin | Signal |
|-----|--------|
| 1 | KCLK |
| 2 | KDAT |
| 3 | NC |
| 4 | GND, and the shell |
| 5 | +5V (through F1, 500mA hold) |

## Reset

The A1200 normally gets Ctrl-Amiga-Amiga from U13 on KB_RESET. A standard Amiga keyboard instead sends a reset warning and then holds KCLK low for 500ms. R1 (220k) and C1 (1µF) only discharge during such a long low (normal clock pulses are microseconds), and U1 (74LVC1G14 Schmitt inverter) then drives KB_RESET through R2 after about 225ms. The same RC holds KB_RESET for a moment at power-on, which is harmless.

KB_RESET is taken as active-high, because the A1200 pulls it down with 10k (R623). If it proves active-low, fit a 74LVC1G17 for U1: same SOT-353 package and pinout, non-inverting.

## Parts

- J1: 1x7 2.54mm vertical header (C492406), cabled to CN17.
- J2: DIN-504 5-pin 180° right-angle socket (C23689428), face on the board edge. Footprint drawn from the datasheet in `lib/A1200KB.pretty`.
- F1: 500mA hold PTC (C69688). Original Amiga keyboards draw more than the A1200KBv2.
- D1, D2: PESD5V0S1BA (C19224) on KCLK and KDAT.
- U1, R1, R2, C1, C2: the reset timer.
- JP1: bridged solder jumper.

The A1200 LED header (CN14) isn't used: the LEDs stay with the A1200's case.
