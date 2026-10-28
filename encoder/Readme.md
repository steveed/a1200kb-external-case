# Encoder: A1200KBv2 as a standard Amiga keyboard

An alternative to the DB37 adapters. An ATmega4809 in the keyboard case scans the A1200KBv2 matrix and speaks the Amiga keyboard protocol on a standard 5-pin DIN, like an A2000 or A3000 keyboard. Plug it into an A1200 fitted with the [`din5`](../din5/Readme.md) board, or straight into an A2000/A3000.

```
A1200KBv2 ── FFC + J2 ── [encoder] ══ DIN 5 cable ══ [din5 board] ── A1200 CN17
                                                  or  A2000 / A3000 keyboard port
```

## DIN 5 pinout

Same as an A2000/A3000 keyboard port: 1 KCLK, 2 KDAT, 3 NC, 4 GND (and the shell), 5 +5V. Use a straight-through male-to-male 5-pin DIN cable with all five pins wired; some MIDI cables only wire three.

## LEDs

The DIN has no LED lines, so the floppy and disk activity LEDs don't work. U1 drives the keyboard's LED header instead:

- PWR (PF1): on whenever the keyboard has power. It also powers the keyboard's Caps Lock LED inverter, so it must be on for the power LED to turn blue with Caps Lock. The A1200's dimmed power LED (audio filter off) is lost.
- FLOPPY (PF2), DISK (PF3): wired but unused; the firmware can use them for anything.
- Caps Lock: handled by the encoder, as on any Amiga keyboard.

## Board

Same outline, mounting holes, J1 and J2 positions as the DB37 adapter, so it fits the case in the same place (`link="din5"` in `case/a1200kb-case.scad` gives the round rear cut-out).

- U1: ATmega4809 (TQFP-48), on its internal oscillator.
- J1: Molex 52044-3245 FFC, as on the adapter. Hand-solder it, or use JLC global sourcing.
- J2: LED header to the keyboard's J2, symmetric as on the adapter: 1 GND, 2 PWR, 3 FLOPPY, 4 DISK, 5 GND.
- J3: DIN-504 5-pin 180° socket (LCSC C23689428), its face on the rear edge, centred at x 134. The footprint in `lib/A1200KB.pretty` is drawn from the datasheet.
- J4: UPDI programming header (1 UPDI, 2 +5V, 3 GND, 4 TXD debug). Not fitted by JLC; solder it yourself or use pogo pins.
- KCLK and KDAT go out through 100Ω with 10k pull-ups and ESD diodes.
- R5 (150Ω) sets the Caps Lock LED current; the keyboard's LED anode is on VCC and U1 sinks it.

## Matrix wiring

The keyboard matrix has no diodes: 6 rows and 7 modifiers against 16 columns. The firmware drives one column low at a time and reads the other 13 lines with pull-ups enabled.

- FFC 1-5, 7 (rows): PA2-PA7
- FFC 6, 8, 10-14 (modifiers): PB0-PB5, PE0
- FFC 15-22 (columns): PD0-PD7; FFC 23-30: PC0-PC7
- FFC 9: VCC; FFC 31: /CAPSLOCK through R5 to PF0
- KCLK PE1, KDAT PE2, debug TXD PA0

## Firmware

Not written yet. It needs to:

- scan the matrix and block ghost keys, as the original keyboard controller does (no diodes)
- send keycodes with the Amiga keyboard protocol: the power-up stream, the handshake, resync, Caps Lock toggling its own LED
- on Ctrl-Amiga-Amiga, send the reset warning, then hold KCLK low for 500ms (the din5 board turns that into the A1200's KB_RESET)
- turn the power LED on at start-up

## Fab files

`fab/` has Gerbers, drill and the JLC BOM and CPL. Regenerate after any change (see the checks in `CLAUDE.md`).
