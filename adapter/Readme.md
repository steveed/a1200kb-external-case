A1200 keyboard FFC to DB37 adapter, for running an A1200KBv2 keyboard in an external case (e.g. with a Checkmate 1500 Plus).

The A1200 keyboard is a bare matrix scanned by the keyboard controller on the motherboard, so all 31 FFC lines have to travel down the cable. DB25 is too small; DB37 carries them plus the LED header and ground.

One board design is used at both ends:

- Amiga end: FFC from the motherboard keyboard connector to J1, DB37 on the rear panel.
- Keyboard end: FFC from the keyboard's J1 to this board's J1, DB37 on the keyboard case.
- Join the two with a straight-through, fully wired, shielded DB37 **male-male** cable (both boards have female sockets).

DB37 pinout:

- FFC pin n (odd) -> DB37 pin (n+1)/2, FFC pin n (even) -> DB37 pin 19+n/2. FFC 9 is VCC (through F1), FFC 31 is /CAPSLOCK, FFC 32 unused.
- DB37 17 DISK LED, 18 FLOPPY LED, 19 PWR LED, 35-37 GND.
- J2 (LED header, right-angle 1x5): 1 GND, 2 PWR, 3 FLOPPY, 4 DISK, 5 GND. Pins 1-4 match the keyboard's 4-pin J2.

J2 is symmetric on purpose. A reversed plug keeps GND on GND and FLOPPY in the middle; only the PWR and DISK LEDs swap, so nothing is damaged. A plain 4-pin pinout reversed would put an LED output on ground and reverse-power the keyboard's LED inverter (U1). Only the adapter end is protected this way: the far ends of the jumper cables (A1200 LED header, keyboard J2) can still be plugged in backwards.

The A1200 keyboard FFC has no ground pin, so ground only reaches the board through J2. Wire the A1200 LED header to J2 on the Amiga-side board and the keyboard's J2 to J2 on the keyboard-side board (pins 1-4; pin 5 is a spare GND), or the LEDs and ESD diodes have no return. If the case's own LEDs already use the A1200 LED header, use a Y-split cable.

The A1200 LED header (CN14) does not share this pinout: it is 1 PWR, 2 FLOPPY, 3 IDE, 4 CC (unused), 5 GND, and pins 1-4 are driven high straight from VCC. Do not use a straight cable on the Amiga side, or CN14 pin 1 (the power LED driver) lands on J2's GND. Wire CN14 1 → J2 2, CN14 2 → J2 3, CN14 3 → J2 4, CN14 5 → J2 1.

Build options:

- Amiga-side board: fit D1-D34 (SOD-323 5V ESD diodes, keep capacitance low, around 50pF or less) and close JP1 to ground the shell.
- Keyboard-side board: D1-D34 optional, leave JP1 open so the shell is grounded at one end only.
- F1: 1206 PTC, about 100mA hold. VCC only feeds the Caps Lock LED.

Parts:

- J1: Molex 52044-3245, 32-way 1.25mm RA FFC connector (same as the keyboard)
- J3: DB37 female right-angle PCB mount, the common "7.2mm" type: about 8.1mm from the flange to the nearest pin row, 63.5mm mounting holes (CONNFLY DS1037-37FNAKT74-0CC, LCSC C77839). The board edge sits 7.7mm from that row, so the flange overhangs the edge slightly instead of the board poking out past it. Check the footprint against the part you buy.
- J2: 1x5 2.54mm right-angle pin header. Its pins stick out past the top edge, on the same side as the FFC.
- FFC cables: 31-way 1.25mm. Use the same contact type as the keyboard's cable, then check with a meter that FFC pin 1 reaches DB37 pin 1 on each board before powering up.

JLCPCB assembly:

- Upload the gerber zip of `fab/` (gerbers and drill), then `fab/A1200KB-DB37-bom.csv` and `fab/A1200KB-DB37-cpl.csv`. Both come from `jlc-export.sh` (run from the repo root).
- The diodes are on the bottom and F1 is on the top, so it needs two-sided Standard PCBA, with through-hole assembly for J1-J3.
- LCSC parts: D1-D34 C19224, F1 C70065, J2 C32713264, J3 C77839. J1 (Molex 52044-3245) isn't stocked at LCSC; the BOM gives the MPN for JLC's global sourcing.
- D1-D34 are bidirectional, so a 180° rotation in JLC's preview doesn't matter. Check the J3 and J2 rotations in the preview.
- This fits the diodes on every board; on keyboard-side boards they are harmless. JP1 is a solder jumper: bridge it by hand on the Amiga-side boards.

Don't plug or unplug the cable with the Amiga powered.

License: CC-BY-NC-SA 4.0
