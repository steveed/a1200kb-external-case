// Coloured scenes for the docs. The case parts come in as STLs exported by render.sh through
// the CGAL backend (OpenSCAD's own view of manifold output draws sliver artefacts on flat faces).
include <../case/a1200kb-case.scad>

scene = "assembly";     // [assembly, exploded, inside]
parts = "";             // folder holding the exported part STLs
TRAY = "#e6e0cf";
LID = "#d9d2bd";

module part_stl(name) import(str(parts, "/", name, ".stl"));

if (scene == "assembly") {
    color(TRAY) part_stl(str("tray-", link));
    color(LID) part_stl("lid");
    ghost_keyboard();
} else if (scene == "exploded") {
    color(TRAY) translate([-12, 0, 0]) part_stl(str("tray_left-", link));
    color("#cfc8b3") translate([12, 0, 0]) part_stl("tray_right");
    ghost_bar();
    ghost_adapter();
    translate([0, 0, 45]) ghost_keyboard();
    translate([0, 0, 95]) {
        color(LID) translate([-12, 0, 0]) part_stl("lid_left");
        color("#c9c1aa") translate([12, 0, 0]) part_stl("lid_right");
    }
} else if (scene == "inside") {
    color(TRAY) part_stl(str("tray-", link));
    ghost_bar();
    ghost_adapter();
}
