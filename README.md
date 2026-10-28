# A1200KB external case

Run an [A1200KBv2](https://github.com/aeberbach/A1200KBv2) mechanical keyboard in its own external case, connected by cable to an A1200 motherboard in a case with no built-in keyboard, such as the Checkmate 1500 Plus.

Normally an external case means a PS/2 or USB keyboard and an adapter. This project keeps the real A1200 keyboard instead.

![The case](docs/images/case-hero.png)

**Setting one up, or stuck?** The [setup guide](docs/Readme.md) shows each way of connecting, what (if anything) has to change on the A1200, the cable wiring, and a troubleshooting table.

## How it works

The A1200 keyboard has no controller of its own. It is a bare switch matrix scanned by the keyboard controller on the motherboard, so every one of the 31 lines on the keyboard ribbon (FFC) has to reach the motherboard. DB25 has too few pins, so this uses DB37:

```
A1200 motherboard ── FFC ── [adapter] ══ DB37 cable ══ [adapter] ── FFC ── A1200KBv2 keyboard
     LED header ──────────── J2                         J2 ──────────────── keyboard LED header
```

Both ends use the same adapter board. See [`adapter/Readme.md`](adapter/Readme.md) for the pinout, build options and parts.

### Alternative: standard Amiga keyboard (DIN 5)

On A1200 boards with the CN17 "KB TEST" header, the keyboard controller's serial lines are available directly:

```
A1200KBv2 ── [encoder] ══ DIN 5 cable ══ [din5 board] ── A1200 CN17
```

- [`din5/`](din5/Readme.md) gives the A1200 a standard 5-pin DIN keyboard socket. An A2000/A3000 keyboard (or an A4000 one through a PS/2-to-AT adapter) plugs straight in. No firmware.
- [`encoder/`](encoder/Readme.md) turns the A1200KBv2 into a standard Amiga keyboard with that same DIN 5, so it also works on an A2000/A3000. It has the same outline as the DB37 adapter, so either fits the case. The activity LEDs don't come across; the power LED does.

## Contents

- `adapter/` — KiCad 10 project for the FFC ⇄ DB37 adapter board, with Gerbers in `adapter/fab/`
- `encoder/` — KiCad 10 project for the A1200KBv2 to Amiga keyboard (DIN 5) encoder, with Gerbers in `encoder/fab/`
- `din5/` — KiCad 10 project for the A1200 standard keyboard socket (CN17 to DIN 5), with Gerbers in `din5/fab/`
- `lib/A1200KB.pretty` — footprints shared by those boards (DIN 5)
- `case/` — OpenSCAD model of the keyboard case (see [`case/Readme.md`](case/Readme.md))
- `docs/` — setup guide, wiring diagrams and renders (`docs/render.sh` regenerates the images)

## Status

Rev 1 of the adapter is designed but not built or tested. The encoder and din5 boards are designed and routed; the encoder has no firmware yet. Before ordering adapter boards:

- Check the DB37 footprint against the connector you buy.
- Choose the ESD diodes (low capacitance, about 50pF or less).
- Hand-wire a test rig with DB37 screw-terminal breakouts to confirm the A1200 scans the matrix reliably over the full cable length.

## License

CC-BY-NC-SA 4.0, the same as A1200KBv2, whose FFC footprint this reuses. See `LICENSE`.
