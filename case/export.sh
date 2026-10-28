#!/bin/bash
# Export every printable part of the case to case/stl/. Run from the repo root.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p stl
for p in tray_left tray_right lid_left lid_right spacers; do
  openscad --backend=manifold --export-format=binstl -D "part=\"$p\"" -o "stl/$p.stl" a1200kb-case.scad 2>&1 \
    | { grep -E 'WARNING|ERROR' || true; }
done
# the rear cut-out is in the left tray half; this one takes the DIN 5 encoder instead of the DB37 adapter
openscad --backend=manifold --export-format=binstl -D 'part="tray_left"' -D 'link="din5"' -o stl/tray_left-din5.stl \
  a1200kb-case.scad 2>&1 | { grep -E 'WARNING|ERROR' || true; }
openscad --imgsize=1600,1000 --camera=233,98,0,55,0,20,950 --colorscheme=Tomorrow \
  -o stl/assembly.png a1200kb-case.scad 2>&1 | { grep -E 'WARNING|ERROR' || true; }
echo "Wrote case/stl/"
