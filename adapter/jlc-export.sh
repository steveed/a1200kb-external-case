#!/bin/bash
# Write JLCPCB assembly files (BOM + CPL) into adapter/fab/ from the schematic's LCSC/MPN fields
# and the board's footprint positions. Run from the repo root after the gerber/drill export.
set -euo pipefail
K=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
PY=/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3
B=adapter/A1200KB-DB37
OUT=adapter/fab
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

$K sch export bom --fields 'Value,Reference,Footprint,LCSC,MPN' \
  --labels 'Comment,Designator,Footprint,LCSC Part #,MPN' \
  --group-by Value,Footprint,LCSC --ref-range-delimiter '' --exclude-dnp \
  -o "$OUT/A1200KB-DB37-bom.csv" "$B.kicad_sch" 2>&1 | { grep -iv fontconfig || true; }

$K pcb export pos --format csv --units mm --side both --exclude-dnp \
  -o "$tmp/pos.csv" "$B.kicad_pcb" 2>&1 | { grep -iv fontconfig || true; }

# KiCad pos -> JLC CPL: rename columns, Top/Bottom layer, rotation in 0..360
$PY -I - "$tmp/pos.csv" "$OUT/A1200KB-DB37-cpl.csv" <<'EOF'
import csv, sys
rows = list(csv.DictReader(open(sys.argv[1])))
with open(sys.argv[2], 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['Designator', 'Mid X', 'Mid Y', 'Layer', 'Rotation'])
    for r in sorted(rows, key=lambda r: (r['Ref'][0], int(''.join(c for c in r['Ref'] if c.isdigit()) or 0))):
        w.writerow([r['Ref'], '%.3fmm' % float(r['PosX']), '%.3fmm' % float(r['PosY']),
                    r['Side'].capitalize(), '%g' % (float(r['Rot']) % 360)])
EOF
echo "Wrote $OUT/A1200KB-DB37-bom.csv and $OUT/A1200KB-DB37-cpl.csv"
