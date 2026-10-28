#!/bin/bash
# Regenerate every image in docs/images/: wiring diagrams, 3D board renders, case views.
# Run from anywhere; needs KiCad 10, OpenSCAD and python3. The case views take a few minutes (CGAL).
set -euo pipefail
cd "$(dirname "$0")/.."
K=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
IMG=docs/images
mkdir -p "$IMG"
quiet() { grep -E 'ERROR|WARNING|Error' || true; }

python3 docs/diagrams.py

# boards: an angled view from the connector edge, and a plain top view for the labels
for b in adapter/A1200KB-DB37 encoder/A1200KB-Encoder din5/A1200KB-DIN5; do
  n=$(basename "$b")
  $K pcb render --quality high --rotate '-50,0,25' --perspective --zoom 0.85 -w 1600 -h 1000 \
    --background opaque -o "$IMG/$n-angle.png" "$b.kicad_pcb" 2>&1 | quiet
  $K pcb render --quality basic --side top --zoom 0.95 -w 1600 -h 1000 \
    --background opaque -o "$IMG/$n-top.png" "$b.kicad_pcb" 2>&1 | quiet
done

# case parts through CGAL, then coloured scenes
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/p.scad" <<EOF
include <$PWD/case/a1200kb-case.scad>
if (which == "tray") tray();
if (which == "lid") lid();
if (which == "tray_left") left() tray();
if (which == "tray_right") right() tray();
if (which == "lid_left") left() lid();
if (which == "lid_right") right() lid();
EOF
ex() { openscad --backend=cgal --export-format=binstl -D 'part="none"' -D "link=\"$1\"" -D "which=\"$2\"" -o "$tmp/$3.stl" "$tmp/p.scad" 2>&1 | quiet; }
for l in db37 din5; do ex $l tray tray-$l; ex $l tray_left tray_left-$l; done
ex db37 tray_right tray_right; ex db37 lid lid; ex db37 lid_left lid_left; ex db37 lid_right lid_right

view() {  # name scene link camera
  openscad --render --imgsize=1600,1000 --colorscheme=Tomorrow --camera="$4" \
    -D "scene=\"$2\"" -D "link=\"$3\"" -D "parts=\"$tmp\"" -D 'part="none"' -o "$IMG/$1.png" docs/scene.scad 2>&1 | quiet
}
view case-hero assembly db37 233,90,10,62,0,335,820
view case-assembly assembly db37 233,98,0,55,0,25,1050
view case-exploded exploded db37 233,98,60,60,0,25,1250
view case-inside-db37 inside db37 233,110,0,50,0,195,780
view case-inside-din5 inside din5 233,110,0,50,0,195,780
view case-rear-db37 inside db37 160,190,15,75,0,180,260
view case-rear-din5 inside din5 160,190,15,75,0,180,260
echo "Wrote $IMG/"
