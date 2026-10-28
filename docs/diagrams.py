"""Write the wiring diagrams in docs/images/ as SVG. Run from the repo root: python3 docs/diagrams.py"""
import os

OUT = os.path.join(os.path.dirname(__file__), 'images')
FONT = 'font-family="Helvetica, Arial, sans-serif"'
AMIGA = '#d9534f'      # A1200 motherboard
BOARD = '#2e7d32'      # boards from this project
KB = '#1565c0'         # keyboards
GREY = '#666'


class Svg:
    def __init__(self, w, h):
        self.w, self.h, self.items = w, h, []

    def box(self, x, y, w, h, title, colour, lines=(), fill='#fff'):
        self.items.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="{fill}" stroke="{colour}" stroke-width="2.5"/>')
        self.text(x + w / 2, y + 22, title, 15, colour, 'middle', bold=True)
        for i, l in enumerate(lines):
            self.text(x + w / 2, y + 42 + i * 17, l, 12.5, '#333', 'middle')

    def text(self, x, y, s, size=13, colour='#333', anchor='start', bold=False, italic=False):
        s = s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        style = (' font-weight="bold"' if bold else '') + (' font-style="italic"' if italic else '')
        self.items.append(f'<text x="{x}" y="{y}" font-size="{size}" fill="{colour}" text-anchor="{anchor}"{style} {FONT}>{s}</text>')

    def line(self, x1, y1, x2, y2, colour='#333', width=2, dash=None):
        d = f' stroke-dasharray="{dash}"' if dash else ''
        self.items.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{colour}" stroke-width="{width}"{d}/>')

    def cable(self, x1, y, x2, label, colour='#333', thick=False):
        if thick:
            self.line(x1, y - 3, x2, y - 3, colour, 2); self.line(x1, y + 3, x2, y + 3, colour, 2)
        else:
            self.line(x1, y, x2, y, colour, 3)
        self.text((x1 + x2) / 2, y - 10, label, 12, colour, 'middle')

    def pins(self, x, y, names, side, colour, title, pitch=26):
        """a header drawn as a column of numbered pins; returns {pin: (x, y)} of the connection points"""
        w = 150
        self.items.append(f'<rect x="{x}" y="{y}" width="{w}" height="{pitch * len(names) + 34}" rx="6" fill="#fff" stroke="{colour}" stroke-width="2.5"/>')
        self.text(x + w / 2, y + 21, title, 14, colour, 'middle', bold=True)
        pts = {}
        for i, n in enumerate(names):
            py = y + 44 + i * pitch
            px = x + w if side == 'right' else x
            self.items.append(f'<circle cx="{px}" cy="{py - 4}" r="5" fill="{colour}"/>')
            label = f'{i + 1}  {n}' if side == 'right' else f'{n}  {i + 1}'
            self.text(px - 12 if side == 'right' else px + 12, py, label, 12.5, '#333', 'end' if side == 'right' else 'start')
            pts[i + 1] = (px, py - 4)
        return pts

    def save(self, name):
        os.makedirs(OUT, exist_ok=True)
        body = '\n'.join(self.items)
        open(os.path.join(OUT, name), 'w').write(
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" height="{self.h}" viewBox="0 0 {self.w} {self.h}">\n'
            f'<rect width="100%" height="100%" fill="#fafafa"/>\n{body}\n</svg>\n')


# ---- the three ways to connect ----
s = Svg(980, 560)
rows = [
    ('A. DB37 adapter pair', 'Any A1200. No firmware. Nothing to solder on the A1200.',
     ('A1200', ['CN13 keyboard socket', 'CN14 LED header']), ('Adapter', ['Amiga side', 'JP1 closed, D1-D34 fitted']),
     'DB37 male-male', ('Adapter', ['keyboard side', 'JP1 open']), ('A1200KBv2', ['FFC + LED header'])),
    ('B. Encoder + DIN 5 socket', 'A1200 with CN17. Needs the encoder firmware.',
     ('A1200', ['CN17 KB TEST header', '(CN14 stays with the case)']), ('din5 board', ['DIN 5 socket', 'JP1 bridged']),
     'DIN 5 cable', ('Encoder', ['ATmega4809', 'Amiga keyboard protocol']), ('A1200KBv2', ['FFC + LED header'])),
    ('C. DIN 5 socket + any Amiga keyboard', 'A1200 with CN17. No firmware.',
     ('A1200', ['CN17 KB TEST header', '(CN14 stays with the case)']), ('din5 board', ['DIN 5 socket', 'JP1 bridged']),
     'keyboard cable', None, ('A2000 / A3000 keyboard', ['A4000: via a PS/2-to-AT', 'adapter'])),
]
for r, (title, sub, amiga, b1, cab, b2, kb) in enumerate(rows):
    y = 20 + r * 180
    s.text(20, y + 18, title, 17, '#222', bold=True)
    s.text(20, y + 38, sub, 13, GREY, italic=True)
    by = y + 55
    s.box(20, by, 170, 95, amiga[0], AMIGA, amiga[1])
    s.cable(190, by + 47, 230, '')
    s.box(230, by, 170, 95, b1[0], BOARD, b1[1])
    if b2:
        s.cable(400, by + 47, 560, cab, '#333', thick=True)
        s.box(560, by, 170, 95, b2[0], BOARD, b2[1])
        s.cable(730, by + 47, 770, '')
        s.box(770, by, 190, 95, kb[0], KB, kb[1])
    else:
        s.cable(400, by + 47, 770, cab, '#333', thick=True)
        s.box(770, by, 190, 95, kb[0], KB, kb[1])
s.save('setups.svg')

# ---- A1200 side, DB37 adapter: CN13 ribbon + CN14 LEDs (remapped) ----
s = Svg(900, 430)
s.text(20, 28, 'A1200 side of the DB37 adapter: nothing is soldered to the A1200', 17, '#222', bold=True)
s.box(20, 50, 230, 90, 'A1200 CN13', AMIGA, ['keyboard ribbon socket', '(where the keyboard tail went)'])
s.box(620, 50, 260, 90, 'Adapter J1', BOARD, ['Molex 52044 FFC socket', 'same as the A1200KBv2'])
s.cable(250, 95, 620, '31-way 1.25mm FFC (as used for the A1200KBv2)')
cn14 = s.pins(100, 175, ['PWR LED', 'FLOPPY LED', 'IDE LED', 'CC (unused)', 'GND'], 'right', AMIGA, 'A1200 CN14')
j2 = s.pins(620, 175, ['GND', 'PWR', 'FLOPPY', 'DISK', 'GND (spare)'], 'left', BOARD, 'Adapter J2')
for a, b in [(1, 2), (2, 3), (3, 4), (5, 1)]:
    s.line(*cn14[a], *j2[b], '#c77700', 2.5)
s.text(450, 405, 'NOT a straight cable: CN14 pin 1 is driven from VCC and J2 pin 1 is GND.', 13, AMIGA, 'middle', bold=True)
s.text(450, 423, 'J2 is also the adapter\'s only ground, so it must be wired even if you don\'t want LEDs.', 12.5, GREY, 'middle')
s.save('a1200-db37.svg')

# ---- A1200 side, din5 board: CN17 only ----
s = Svg(900, 420)
s.text(20, 28, 'A1200 side of the DIN 5 socket: CN17 only', 17, '#222', bold=True)
cn17 = s.pins(100, 55, ['KB_DATA', 'KB_CLOCK', 'KB_RESET', 'U13 reset', 'NC', 'VCC', 'GND'], 'right', AMIGA, 'A1200 CN17')
j1 = s.pins(620, 55, ['KDAT', 'KCLK', 'KB_RESET out', 'to JP1 (GND)', 'NC', 'VCC in', 'GND'], 'left', BOARD, 'din5 J1')
for p in range(1, 8):
    s.line(*cn17[p], *j1[p], '#333', 2.5)
s.text(450, 285, 'Straight 7-way cable, pin 1 to pin 1.', 13, '#222', 'middle', bold=True)
for i, t in enumerate([
        'CN17 is on later boards only (marked "new on Rev 1E PCB"). If your board has the pads but no header,',
        'solder in a 1x7 2.54mm pin header: that is the only change to the A1200 itself.',
        'Leave CN13 (the keyboard ribbon socket) empty. CN14 stays with the case LEDs.',
        'JP1 on the din5 board grounds CN17 pin 4, holding the A1200\'s own keyboard controller (U13) in reset.',
        'Cut JP1 to give U13 back, e.g. to use the original keyboard again.']):
    s.text(450, 315 + i * 19, t, 12.5, GREY if i else AMIGA, 'middle', bold=(i == 1))
s.save('a1200-din5.svg')

# ---- keyboard side: A1200KBv2 to adapter or encoder ----
s = Svg(900, 330)
s.text(20, 28, 'Keyboard side: A1200KBv2 to the DB37 adapter or the encoder (the same on both)', 17, '#222', bold=True)
s.box(20, 50, 230, 90, 'A1200KBv2 J1', KB, ['Molex 52044 FFC socket', '(underside, rear)'])
s.box(620, 50, 260, 90, 'Board J1', BOARD, ['Molex 52044 FFC socket'])
s.cable(250, 95, 620, '31-way 1.25mm FFC')
kb2 = s.pins(100, 160, ['LED GND', 'PWR', 'FLOPPY', 'DISK'], 'right', KB, 'A1200KBv2 J2')
bj2 = s.pins(620, 160, ['GND', 'PWR', 'FLOPPY', 'DISK', 'GND (spare)'], 'left', BOARD, 'Board J2')
for p in range(1, 5):
    s.line(*kb2[p], *bj2[p], '#333', 2.5)
s.text(450, 300, 'Straight 4-way cable to J2 pins 1-4. A reversed plug at the board end only swaps PWR and DISK.', 12.5, GREY, 'middle')
s.text(450, 318, 'The keyboard FFC has no ground: the LED cable is the keyboard\'s only ground, so always fit it.', 12.5, AMIGA, 'middle', bold=True)
s.save('keyboard-side.svg')
print('wrote', sorted(os.listdir(OUT)))
