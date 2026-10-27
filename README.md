# A1200KB external case

Run an [A1200KBv2](https://github.com/aeberbach/A1200KBv2) mechanical keyboard in its own external case, connected by cable to an A1200 motherboard in a case with no built-in keyboard, such as the Checkmate 1500 Plus.

Normally an external case means a PS/2 or USB keyboard and an adapter. This project keeps the real A1200 keyboard instead.

## How it works

The A1200 keyboard has no controller of its own. It is a bare switch matrix scanned by the keyboard controller on the motherboard, so every one of the 31 lines on the keyboard ribbon (FFC) has to reach the motherboard. DB25 has too few pins, so this uses DB37:

```
A1200 motherboard ── FFC ── [adapter] ══ DB37 cable ══ [adapter] ── FFC ── A1200KBv2 keyboard
     LED header ──────────── J2                         J2 ──────────────── keyboard LED header
```

Both ends use the same adapter board. See [`adapter/Readme.md`](adapter/Readme.md) for the pinout, build options and parts.

## Contents

- `adapter/` — KiCad 10 project for the FFC ⇄ DB37 adapter board, with Gerbers in `adapter/fab/`
- keyboard case — not started yet

## Status

Rev 1 of the adapter is designed but not built or tested. Before ordering boards:

- Check the DB37 footprint against the connector you buy.
- Choose the ESD diodes (low capacitance, about 50pF or less).
- Hand-wire a test rig with DB37 screw-terminal breakouts to confirm the A1200 scans the matrix reliably over the full cable length.

## License

CC-BY-NC-SA 4.0, the same as A1200KBv2, whose FFC footprint this reuses. See `LICENSE`.
