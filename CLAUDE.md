# a1200kb-external-case

Hardware project: an external case for the A1200KBv2 keyboard, plus the FFC ⇄ DB37 adapter board that carries the keyboard matrix to an A1200 motherboard. The sibling repo `../A1200KBv2` holds the keyboard PCB itself, and its netlist is the source of truth for the FFC pinout.

## Tooling

There is no docker-compose here. This repo is an exception to the "always use the containers" rule: KiCad is a desktop app and its CLI and Python come from the app bundle.

- KiCad 10: `/Applications/KiCad/KiCad.app`
- CLI: `/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli`
- Python with `pcbnew`: `/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3`
  - pcbnew scripts print a harmless `wxApp` assert and fontconfig warnings; filter them out.
  - `ZONE_FILLER.Fill()` segfaults outside the GUI. Fill zones with `kicad-cli pcb drc --refill-zones --save-board` instead.
  - `pcbnew.FootprintSave` fails; use `pcbnew.PCB_IO_KICAD_SEXPR().FootprintSave(lib, fp)`.

Checks to run after any change to the adapter (all must be clean apart from the 2 J1 silk-edge warnings):

```
K=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
$K sch erc --severity-all adapter/A1200KB-DB37.kicad_sch
$K pcb drc --refill-zones --save-board --schematic-parity --severity-all adapter/A1200KB-DB37.kicad_pcb
$K pcb export gerbers --board-plot-params -o adapter/fab/ adapter/A1200KB-DB37.kicad_pcb
$K pcb export drill -o adapter/fab/ adapter/A1200KB-DB37.kicad_pcb
```

Freerouting is installed as a KiCad plugin. Running the downloaded jar from the CLI needs explicit user approval.

## Adapter design invariants

- One board design serves both ends; both have female DB37 sockets and are joined by a straight-through male-male cable. A pin mapping change must stay symmetric, since the same board is used at both ends.
- FFC pin n → DB37 pin (n+1)/2 for odd n, 19+n/2 for even n. This keeps every trace crossing-free: odd pins on F.Cu, even pins on B.Cu. DB17 DISK, DB18 FLOPPY, DB19 PWRLED, DB35-37 GND.
- FFC pin 9 is VCC (through polyfuse F1), pin 31 is /CAPSLOCK, pin 32 is unused.
- The keyboard FFC has no ground. GND reaches the board through J2 (A1200 LED header, keyboard's own pin order: 1 GND, 2 PWR, 3 FLOPPY, 4 DISK) and, on the Amiga side, J4.
- J4 is a TE 171826-4 floppy power header (`adapter/Connector_Floppy.pretty`, drawn from TE drawing C-171826 R4). Only its GND pins 2 and 3 are connected; leave pins 1 (+5V) and 4 (+12V) unconnected so a reversed plug can't do damage. H1 was moved to (104, 112) to make room for it.
- Schematic edits since the first commit are incremental patches to the KiCad-10-saved file, not regenerations; the file is the source of truth.
- The Amiga-side board fits ESD diodes D1-D34 and closes JP1 (shell to GND); the keyboard side leaves JP1 open.
- `adapter/Amiga_FFC.pretty` is the keyboard's Molex 52044-3245 footprint, copied out of A1200KBv2. On the adapter it is placed at 180° so the cable opening faces the top edge and pin 1 is on the right. It deliberately overhangs the board edge by 1.5mm, as on the keyboard.
- Net names in the PCB carry eeschema's `/` sheet prefix (e.g. `/KB01`); GND has none.
