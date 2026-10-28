# Setup guide

How the pieces fit together, and what each setup asks of the A1200 itself. If your keyboard doesn't work, find your setup below, check the wiring against the diagram, then look at [troubleshooting](#troubleshooting).

The new boards are covered in their own READMEs ([adapter](../adapter/Readme.md), [encoder](../encoder/Readme.md), [din5](../din5/Readme.md)); this page is about the A1200 end and the cables.

## Three ways to connect

![The three setups](images/setups.svg)

| | A. DB37 adapter pair | B. Encoder + DIN 5 socket | C. DIN 5 socket + Amiga keyboard |
|---|---|---|---|
| Soldering on the A1200 | none | only if CN17 has no header fitted | only if CN17 has no header fitted |
| A1200 connectors used | CN13 (keyboard ribbon) and CN14 (LEDs) | CN17 | CN17 |
| A1200's keyboard controller (U13) | does the work, as normal | held in reset by the din5 board | held in reset by the din5 board |
| Keyboard LEDs | power, floppy, disk, Caps Lock | power and Caps Lock | the keyboard's own |
| Firmware | none | encoder firmware | none |
| Which A1200s | any | boards with CN17 | boards with CN17 |

No setup cuts tracks or removes chips on the A1200. The only possible modification is fitting a 7-pin header to CN17 (setups B and C) if your board has the pads but no header.

### The A1200 connectors

The names come from the Commodore A1200 schematic ([amigawiki.org](https://www.amigawiki.org/dnl/schematics/A1200_R1.pdf), sheet 9, "keyboard MPU").

- **CN13**: the keyboard ribbon (membrane) socket, 31 ways. The original keyboard's tail plugs in here. Every line is a raw matrix row or column scanned by U13, the 68HC05 keyboard controller on the motherboard.
- **CN14**: the 5-pin LED header: 1 power LED, 2 floppy LED, 3 IDE LED, 4 CC (its driver is marked optional on the schematic), 5 GND. Pins 1-4 are driven high through PNP transistors straight from VCC.
- **CN17** "KB TEST": 7 pins, 1 KB_DATA, 2 KB_CLOCK, 3 KB_RESET, 4 U13 reset, 5 NC, 6 VCC, 7 GND. These are U13's outputs to the rest of the Amiga, the serial keyboard lines every other Amiga has on its keyboard socket. Grounding pin 4 holds U13 in reset, which frees the lines for an external keyboard. The schematic marks CN17 "new on Rev 1E PCB", so older boards may not have it.

<!-- Photos of CN13, CN14 and CN17 on a real board belong here: docs/images/a1200-connectors.jpg -->

## A. DB37 adapter pair

The same adapter board is used at both ends, joined by a straight-through DB37 male-to-male cable. The Amiga-side board has its ESD diodes fitted and JP1 closed (shell to ground); the keyboard-side board leaves JP1 open.

![A1200 side of the DB37 adapter](images/a1200-db37.svg)

On the A1200:

1. Unplug the original keyboard from CN13 and the LED board from CN14.
2. Connect CN13 to the adapter's J1 with a 31-way 1.25mm FFC, the same kind of cable as the A1200KBv2 uses.
3. Wire CN14 to the adapter's J2 as in the diagram. This is **not** a straight 5-way cable: the A1200 and the adapter number these pins differently, and a straight cable puts the power LED driver on ground.

![DB37 adapter](images/A1200KB-DB37-angle.png)

![DB37 adapter, top](images/A1200KB-DB37-top.png)

J1 (the white FFC socket) faces away from the DB37, with its opening over the top edge. J2 is the 5-pin LED header on the left.

## B and C. DIN 5 socket on CN17

The din5 board gives the A1200 a standard Amiga keyboard socket, wired like an A2000 or A3000. Plug in the A1200KBv2 with the encoder (B), an A2000/A3000 keyboard, or an A4000 keyboard through a passive PS/2-to-AT adapter (C).

![A1200 side of the DIN 5 socket](images/a1200-din5.svg)

On the A1200:

1. Find CN17. If there are pads but no pins, solder in a 1x7 2.54mm pin header.
2. Unplug the original keyboard from CN13 and leave CN13 empty.
3. Connect CN17 to the din5 board's J1 with a straight 7-way jumper cable, pin 1 to pin 1.
4. Leave CN14 for the case's own LEDs; the din5 board doesn't use it.

![DIN 5 socket board](images/A1200KB-DIN5-angle.png)

![DIN 5 socket board, top](images/A1200KB-DIN5-top.png)

JP1 (the yellow pad, left) is bridged as made: it grounds CN17 pin 4 and keeps U13 in reset. Cut the bridge to give U13 back, for example to go back to the original keyboard on CN13. The small chip on the right (U1) turns a standard keyboard's reset request (clock held low for half a second) into the A1200's KB_RESET.

## Keyboard side

The A1200KBv2 connects the same way to either the DB37 adapter or the encoder.

![Keyboard side wiring](images/keyboard-side.svg)

The keyboard ribbon has no ground pin. Ground reaches the keyboard only through the LED cable, so fit it even if you don't care about LEDs: the Caps Lock LED inverter on the keyboard runs from it.

![Encoder](images/A1200KB-Encoder-angle.png)

![Encoder, top](images/A1200KB-Encoder-top.png)

The encoder has the same outline, mounting holes, J1 and J2 as the DB37 adapter, so it sits in the same place in the case. J4 (UPDI) programs the ATmega4809.

## The case

A low wedge tray and lid, each split in two to fit a 256mm print bed. STLs from the current settings are in [`case/stl/`](../case/stl), but some dimensions are still estimates until checked on a built keyboard; see the [case README](../case/Readme.md) for printing and hardware.

![Case with an A1200KBv2](images/case-hero.png)

![Case, assembled](images/case-assembly.png)

![Case, exploded](images/case-exploded.png)

From the bottom: the two tray halves (bolted together through blocks at the split), the aluminium stiffening bar, the rear board, the keyboard on its posts, and the two lid halves. The keyboard screws down through its own PCB holes; with its A1200 mounting brackets fitted it drops straight in, without them it takes the printed spacers.

![Inside, DB37 adapter](images/case-inside-db37.png)

![Inside, DIN 5 encoder](images/case-inside-din5.png)

Inside the tray, from the rear: the posts for the keyboard and lid, the bar standing on edge in its ribs, and the rear board (blue) against the rear wall behind the keyboard's FFC connector. `link` in `case/a1200kb-case.scad` chooses the D cut-out (DB37 adapter) or the round one (DIN 5 encoder).

![Rear, DIN 5](images/case-rear-din5.png)

## Troubleshooting

| Symptom | Setup | Likely cause |
|---|---|---|
| No keys at all | A | FFC cable at CN13 or J1 in the wrong way round or not fully seated; DB37 cable not straight-through. |
| No keys at all | B, C | CN17 cable offset or reversed (pin 1 to pin 1); JP1 cut, so U13 still drives the lines; a DIN cable with only three wires (many MIDI cables). |
| No keys at all | B | Encoder not programmed. |
| A1200's power LED driver gets hot, power LED dead | A | Straight cable on CN14: use the remapped wiring above. |
| Keyboard LEDs dead, or power LED doesn't turn blue with Caps Lock | A, B | LED cable to the keyboard's J2 missing or reversed; it is also the keyboard's only ground. |
| Keys work, Ctrl-Amiga-Amiga doesn't reset | B, C | The keyboard isn't holding the clock low long enough (about 225ms is needed; the standard is 500ms), so check the encoder firmware (B). On the din5 board, check U1, R1 and C1. |
| A1200 stays in reset, or resets on its own | B, C | KB_RESET is active-low on your board, the opposite of what the din5 board assumes: fit a 74LVC1G17 for U1. |
| Phantom keys when holding several at once | A, B | Expected with this matrix: like the original A1200 keyboard it has no diodes, so some combinations of three or more keys can't be told apart. |

## Regenerating the images

`docs/render.sh` rebuilds everything in `docs/images/`: the wiring diagrams (`docs/diagrams.py`), the KiCad 3D renders and the OpenSCAD case views. The FFC socket and DIN 5 3D models in `lib/A1200KB.3dshapes/` are simplified shapes, there to show what plugs in where.
