A1200 keyboard FFC to DB37 adapter, for running an A1200KBv2 keyboard in an external case (e.g. with a Checkmate 1500 Plus).

The A1200 keyboard is a bare matrix scanned by the keyboard controller on the motherboard, so all 31 FFC lines have to travel down the cable. DB25 is too small; DB37 carries them plus the LED header and ground.

One board design is used at both ends:

- Amiga end: FFC from the motherboard keyboard connector to J1, DB37 on the rear panel.
- Keyboard end: FFC from the keyboard's J1 to this board's J1, DB37 on the keyboard case.
- Join the two with a straight-through, fully wired, shielded DB37 **male-male** cable (both boards have female sockets).

DB37 pinout:

- FFC pin n (odd) -> DB37 pin (n+1)/2, FFC pin n (even) -> DB37 pin 19+n/2. FFC 9 is VCC (through F1), FFC 31 is /CAPSLOCK, FFC 32 unused.
- DB37 17 DISK LED, 18 FLOPPY LED, 19 PWR LED, 35-37 GND.
- J2 (LED header): 1 GND, 2 PWR, 3 FLOPPY, 4 DISK, same order as J2 on the keyboard.

The A1200 keyboard FFC has no ground pin, so ground has to come in from outside:

- Amiga-side board: plug a 3.5" floppy power lead from the PSU into J4 (TE 171826-4), or wire the A1200 LED header to J2. J4 connects only its two GND pins (2 and 3); +5V and +12V are left unconnected, so a reversed plug is harmless. J4's posts stick out past the top edge, on the same side as the FFC.
- Keyboard-side board: wire the keyboard's J2 to J2. Leave J4 unfitted.

Without one of these the LEDs and ESD diodes have no return.

Build options:

- Amiga-side board: fit D1-D34 (SOD-323 5V ESD diodes, keep capacitance low, around 50pF or less) and close JP1 to ground the shell.
- Keyboard-side board: D1-D34 optional, leave JP1 open so the shell is grounded at one end only.
- F1: 1206 PTC, about 100mA hold. VCC only feeds the Caps Lock LED.

Parts:

- J1: Molex 52044-3245, 32-way 1.25mm RA FFC connector (same as the keyboard)
- J3: DB37 female right-angle PCB mount, 9.9mm pin-to-edge, 63.5mm mounting holes. Check the footprint against the part you buy.
- J2: 1x4 2.54mm header
- J4: TE 171826-4, 4-pin 2.5mm right-angle floppy power header (Amiga side only). Footprint drawn from TE customer drawing C-171826 rev R4.
- FFC cables: 31-way 1.25mm. Use the same contact type as the keyboard's cable, then check with a meter that FFC pin 1 reaches DB37 pin 1 on each board before powering up.

Don't plug or unplug the cable with the Amiga powered.

License: CC-BY-NC-SA 4.0
