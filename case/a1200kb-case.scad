// External case for an A1200KBv2 keyboard and the FFC-DB37 adapter.
// Low wedge, tray + lid, each split left/right to fit a 256mm bed (Bambu P2S).
//
// Frame: x right, y towards the rear, z up; origin at the front-left-bottom outer corner.
// Keyboard and adapter features are given in their own KiCad coordinates (mm, y towards
// the front) and mapped with kb() / ad().
//
// The keyboard screws down through its own PCB holes onto posts with M3 heat-set inserts.
// Seven of those holes carry the KBv2 brackets; their posts stop a bracket's thickness short,
// so a keyboard with brackets drops straight in and one without takes the printed spacers.
//
// Export: case/export.sh, or openscad -D 'part="tray_left"' ...

part = "assembly"; // [assembly, exploded, inside, tray_left, tray_right, lid_left, lid_right, spacers]
link = "db37";      // [db37, din5] which rear board: the DB37 adapter or the DIN 5 encoder

/* [Shell] */
wall = 2.4;
floor_t = 2.4;
lid_t = 2.4;
corner_r = 6;
chamfer = 1.5;          // lid top edge
side_gap = 6;           // PCB side edge to inside of wall
front_gap = 12;         // PCB front edge to inside of front wall (room for the lid posts)
rear_space = 44;        // PCB rear edge to inside of rear wall: FFC run, J2 overhang, adapter

/* [Keyboard] */
pcb = [450.15, 135.15];
pcb_min = [39.92, 29.93];   // KiCad rear-left corner of the KBv2 PCB
pcb_t = 1.6;
plate_h = 5.0;          // PCB top to plate top. ESTIMATE: measure (A2)
key_h = 14;             // plate top to keycap top, ghost only. ESTIMATE: measure (A3)
kb_tilt = 4;            // degrees, rear up
kb_front_z = 14;        // PCB underside at its front edge, from the table
lid_gap = 0.4;          // plate top to lid underside
side_bracket_t = 3.4;   // left/right bracket strip, from the KBv2 STL
lower_bracket_t = 3.8;  // lower bracket strip, from the KBv2 STL
// [x, y, what sits between PCB and post]; bracket thicknesses from the KBv2 STLs
kb_holes = [
    [45, 64.86, side_bracket_t], [155, 64.86, 0], [265, 64.86, 0], [375, 64.86, 0],
    [485, 64.86, side_bracket_t], [45, 127, side_bracket_t], [485, 127, side_bracket_t],
    [155, 160, lower_bracket_t], [265, 160, lower_bracket_t], [375, 160, lower_bracket_t]];
// keycap envelope, KiCad coords [x0, y0, x1, y1]: function row, then the main block
kb_keys = [[41.2, 40.9, 317.3, 69.6], [41.2, 69.5, 488.3, 164.9]];
key_clear = 0.8;
kb_j1 = [192.75, 36.25];    // FFC connector, underside, opening to the rear
// LED exits, KiCad coords: power (D7/D6), floppy (D8), disk (D9). Light pipe exits are
// assumed straight above the LEDs until the pipes are measured (A17-A19).
leds = [[467.3, 58.3], [467.23, 50.32], [467.19, 42.31]];
led_win = [6.4, 2.6];
led_pocket = [30, 32, 1.2];     // lid underside relief over the light pipe shield
led_pocket_c = [467.2, 50.3];

/* [Stiffening bar] */
bar = [400, 3, 10];     // 10x3 aluminium flat, on edge, along x
bar_v = 70;             // distance behind the PCB front edge
bar_lift = 1.5;         // floor to bar underside
rib_x = [75, 125, 175, 225, 275, 325, 375, 425, 455];   // KiCad x
rib = [12, 10, 9];      // rib length, width, height above floor
bar_slot = 3.3;

/* [Adapter] */
ad_dx = kb_j1.x - 141.75;   // line the adapter's J1 up with the keyboard's
ad_edge = 129.54;           // adapter bottom edge (DB37 flange side), KiCad y
ad_holes = [[104, 112], [170.5, 104.5]];
ad_post_h = 5;              // floor to adapter underside; clears THT pins
db_flange_t = 1.0;          // flange between board edge and wall. CHECK on the part
db_c = 137.57;              // DB37 centre, adapter KiCad x
db_ch = 6.25;               // PCB top to flange centre (KiCad 3D model)
db_cut = [56.8, 53.8, 9.0];     // D cut-out: top width, bottom width, height. Trial fit
db_jack = 63.5;
din_c = 134;                // DIN 5 centre, encoder KiCad x
din_ch = 10;                // DIN 5: PCB top to socket centre (DIN-504 datasheet)
din_hole = 15;              // DIN 5: round cut-out for the plug. Trial fit
edge_gap = link == "db37" ? db_flange_t : 0;    // the DIN 5 face sits on the board edge

/* [Fixings] */
post_d = 9;
insert_d = 4.0;             // M3 heat-set insert hole
insert_l = 6.5;
lid_boss_l = 7;
lid_posts = [[60, "f"], [125, "f"], [400, "f"], [470, "f"],
             [60, "r"], [120, "r"], [300, "r"], [460, "r"]];   // KiCad x, front/rear strip
split_kx = 250;             // KiCad x of the left/right split
jb_x = 8;                   // joint block length each side of the split

$fn = 48;

include <kbv2-keys.scad>
eps = 0.01;

// ---- derived ----
inner = [pcb.x + 2 * side_gap, front_gap + pcb.y + rear_space];
outer = inner + [2 * wall, 2 * wall];
kb_x0 = wall + side_gap;
kb_y0 = wall + front_gap;
rear_in = wall + inner.y;
lid_w0 = pcb_t + plate_h + lid_gap;
split_x = kb_x0 + split_kx - pcb_min.x;

function kbl(p) = [p.x - pcb_min.x, pcb_min.y + pcb.y - p.y];      // keyboard-plane coords
function kb(p) = [kb_x0, kb_y0] + kbl(p);                           // case plan coords
function ad(p) = [kb_x0 + p.x + ad_dx - pcb_min.x, rear_in - edge_gap - (ad_edge - p.y)];
// z of the plane w above the PCB underside, at case y
function plane_z(y, w) = kb_front_z + (y - kb_y0) * tan(kb_tilt) + w / cos(kb_tilt);
ad_z = floor_t + ad_post_h;     // adapter underside
db_z = ad_z + pcb_t + db_ch;
bar_y = kb_y0 + bar_v * cos(kb_tilt);
bar_top = floor_t + bar_lift + bar.z;

echo(str("case ", outer.x, " x ", outer.y, ", left ", split_x, ", right ", outer.x - split_x));
echo(str("height front ", plane_z(0, lid_w0 + lid_t), ", rear ", plane_z(outer.y, lid_w0 + lid_t)));
echo(str("bar clearance under PCB ", plane_z(bar_y, 0) - bar_top));
assert(split_x <= 256 && outer.x - split_x <= 256, "half too wide for the bed");

module kb_frame() translate([kb_x0, kb_y0, kb_front_z]) rotate([kb_tilt, 0, 0]) children();

// slab between keyboard-plane heights w0 and w1, wider than the case
module kb_slab(w0, w1) kb_frame() translate([-50, -100, w0]) cube([outer.x + 100, outer.y + 200, w1 - w0]);

module footprint(off = 0) offset(r = corner_r + off) offset(delta = -corner_r) square(outer);

// footprint as seen in the keyboard plane at height w
module kb_footprint(off, w) scale([1, 1 / cos(kb_tilt)]) translate([-kb_x0, -kb_y0 + w * sin(kb_tilt)]) footprint(off);

module rrect(c0, c1, r = 1) translate(c0 + [r, r]) offset(r = r) square(c1 - c0 - [2 * r, 2 * r]);

// ---- tray ----

module kb_posts() for (h = kb_holes) kb_frame() translate([each kbl(h), -h[2]]) mirror([0, 0, 1]) cylinder(d = post_d, h = 60);

module kb_post_holes() for (h = kb_holes) kb_frame() translate([each kbl(h), -h[2] + eps]) mirror([0, 0, 1]) {
    cylinder(d = insert_d, h = insert_l);
    cylinder(d = 2.8, h = insert_l + 5);
}

module bar_ribs() for (x = rib_x) translate([kb([x, 0]).x - rib.x / 2, bar_y - rib.y / 2, 0]) cube([rib.x, rib.y, floor_t + rib.z]);

module bar_slots() for (x = rib_x) translate([kb([x, 0]).x - rib.x / 2 - 1, bar_y - bar_slot / 2, floor_t + bar_lift]) cube([rib.x + 2, bar_slot, 50]);

module ad_posts() for (h = ad_holes) translate([each ad(h), 0]) cylinder(d = 8, h = ad_z);

module ad_post_holes() for (h = ad_holes) translate([each ad(h), ad_z - insert_l]) cylinder(d = insert_d, h = insert_l + eps);

function lid_post_xy(p) = [kb([p[0], 0]).x, p[1] == "f" ? wall + front_gap / 2 : rear_in - 5];

module lid_posts_tray() for (p = lid_posts) let(c = lid_post_xy(p))
    translate([each c, 0]) cylinder(d = 8, h = plane_z(c.y - 4, lid_w0) - lid_boss_l);

module lid_post_holes_tray() for (p = lid_posts) let(c = lid_post_xy(p)) translate([each c, -eps]) {
    cylinder(d = 3.4, h = 100);
    cylinder(d = 6.5, h = 3);
}

module link_cutout() if (link == "db37") db_cutout(); else
    translate([ad([din_c, 0]).x, rear_in - eps - 1, ad_z + pcb_t + din_ch]) rotate([-90, 0, 0]) cylinder(d = din_hole, h = wall + 2 + 2 * eps);

module db_cutout() {
    x = ad([db_c, 0]).x;
    translate([x, rear_in - eps - 1, db_z]) rotate([-90, 0, 0]) {
        linear_extrude(wall + 2 + 2 * eps) hull() for (s = [-1, 1]) {
            translate([s * (db_cut[0] / 2 - 1.2), -db_cut[2] / 2 + 1.2]) circle(r = 1.2);
            translate([s * (db_cut[1] / 2 - 1.2), db_cut[2] / 2 - 1.2]) circle(r = 1.2);
        }
        for (s = [-1, 1]) translate([s * db_jack / 2, 0, 0]) cylinder(d = 3.4, h = wall + 2 + 2 * eps);
    }
}

module feet() for (x = [16, outer.x - 16], y = [16, outer.y - 16]) translate([x, y, -eps]) cylinder(d = 12, h = 1.2);

// joint across the split: block, bolt along x, nut trap on the right half
module joint_block(y0, d, z0, z1) translate([split_x - jb_x, y0, z0]) cube([2 * jb_x, d, z1 - z0]);
module joint_holes(y0, d, zc) translate([0, y0 + d / 2, zc]) rotate([0, 90, 0]) {
    translate([0, 0, split_x - jb_x - 1]) cylinder(d = 3.4, h = 2 * jb_x + 2);
    translate([0, 0, split_x - jb_x - 1]) cylinder(d = 6.2, h = 4);
    translate([0, 0, split_x + jb_x - 2.6]) rotate([0, 0, 30]) cylinder(d = 6.6, h = 3.6, $fn = 6);
}

tray_joints = [   // [y0, depth, z0, z1]
    [wall, 8, 0, floor_t + 10],
    [kb_y0 + 34, 10, 0, floor_t + 9],     // behind the lower bracket, in front of the bar
    [kb_y0 + 108, 10, 0, floor_t + 9],
    [rear_in - 9, 9, 0, floor_t + 16]];

module inside() intersection() {
    translate([0, 0, floor_t - eps]) linear_extrude(200) footprint(-wall + eps);
    kb_slab(-300, lid_w0);
}

module tray() difference() {
    union() {
        difference() {
            intersection() {
                linear_extrude(200) footprint();
                kb_slab(-300, lid_w0);
            }
            inside();
        }
        intersection() {
            union() {
                translate([0, 0, floor_t - eps]) linear_extrude(200) footprint(-wall + eps);
                translate([0, 0, -1]) cube([outer.x, outer.y, floor_t]);
            }
            union() {
                kb_posts();
                bar_ribs();
                ad_posts();
                lid_posts_tray();
                for (j = tray_joints) joint_block(j[0], j[1], j[2], j[3]);
            }
            kb_slab(-300, lid_w0);
            translate([-1, -1, 0]) cube([outer.x + 2, outer.y + 2, 200]);
        }
    }
    kb_post_holes();
    bar_slots();
    ad_post_holes();
    lid_post_holes_tray();
    link_cutout();
    feet();
    for (j = tray_joints) joint_holes(j[0], j[1], (max(j[2], floor_t) + j[3]) / 2);
}

// ---- lid ----

function lid_under(y) = plane_z(y, lid_w0);

lid_joints = [    // [y0, depth, hang]
    [wall + 0.4, 8, 6.5],
    [rear_in - 22, 8, 8]];

module lid_slab() intersection() {
    linear_extrude(200) footprint();
    kb_frame() hull() {
        translate([0, 0, lid_w0]) linear_extrude(lid_t - chamfer) kb_footprint(0, lid_w0);
        translate([0, 0, lid_w0]) linear_extrude(lid_t) kb_footprint(-chamfer, lid_w0 + lid_t);
    }
}

module lid_lip() difference() {
    intersection() {
        linear_extrude(200) difference() { footprint(-wall - 0.3); footprint(-wall - 1.9); }
        kb_slab(lid_w0 - 3, lid_w0 + eps);
    }
    translate([split_x - 14, -1, 0]) cube([28, outer.y + 2, 200]);
}

module lid_bosses() for (p = lid_posts) let(c = lid_post_xy(p))
    translate([each c, lid_under(c.y + 4) - lid_boss_l]) cylinder(d = 8, h = lid_boss_l + 1);

module lid_boss_holes() for (p = lid_posts) let(c = lid_post_xy(p))
    translate([each c, lid_under(c.y + 4) - lid_boss_l - eps]) cylinder(d = insert_d, h = insert_l);

module kb_opening() kb_frame() translate([0, 0, lid_w0 - 1]) linear_extrude(lid_t + 2)
    for (k = kb_keys) rrect(kbl([k[0], k[3]]) - [key_clear, key_clear], kbl([k[2], k[1]]) + [key_clear, key_clear]);

module led_windows() kb_frame() {
    for (l = leds) translate([each kbl(l), lid_w0 - 1]) linear_extrude(lid_t + 2) square(led_win, center = true);
    translate([each kbl(led_pocket_c), lid_w0 - eps]) linear_extrude(led_pocket.z) square([led_pocket.x, led_pocket.y], center = true);
}

// two shallow grooves across the rear spine
module lid_grooves() kb_frame() for (i = [0, 1]) let(v = pcb.y + 12 + i * 6)
    translate([corner_r + 10 - kb_x0, v, lid_w0 + lid_t - 0.8]) cube([outer.x - 2 * corner_r - 20, 2, 1]);

module lid() difference() {
    union() {
        lid_slab();
        lid_lip();
        lid_bosses();
        for (j = lid_joints) joint_block(j[0], j[1], lid_under(j[0]) - j[2], lid_under(j[0] + j[1]) + 0.5);
    }
    kb_opening();
    led_windows();
    lid_grooves();
    lid_boss_holes();
    for (j = lid_joints) joint_holes(j[0], j[1], lid_under(j[0]) - j[2] + 4);
}

// ---- spacers for a keyboard without brackets ----

module spacers() {
    for (i = [0 : 3]) translate([i * 12, 0, 0]) difference() { cylinder(d = 8, h = side_bracket_t); translate([0, 0, -1]) cylinder(d = 3.4, h = 10); }
    for (i = [0 : 2]) translate([i * 12, 12, 0]) difference() { cylinder(d = 8, h = lower_bracket_t); translate([0, 0, -1]) cylinder(d = 3.4, h = 10); }
}

// ---- ghosts ----

// one keycap, tapered, centred on its switch; iso = ISO Enter (wide at the rear)
module keycap(w, h, iso) {
    u = 19.05;
    module outline(inset) offset(r = 1) offset(delta = -1 - inset)
        if (iso) {
            translate([-0.75 * u, 0]) square([1.5 * u - 0.8, u - 0.8]);
            translate([0.75 * u - 1.25 * u + 0.4, -u + 0.4]) square([1.25 * u - 0.8, 2 * u - 0.8]);
        } else square([w * u - 0.8, h * u - 0.8], center = true);
    hull() {
        linear_extrude(0.1) outline(0);
        translate([0, 0, key_h - 3 - 0.1]) linear_extrude(0.1) outline(2.2);
    }
}

module ghost_keyboard() kb_frame() {
    color("darkgreen") linear_extrude(pcb_t) square(pcb);
    color("#2b2b2b") translate([0, 0, pcb_t + plate_h - 3]) linear_extrude(3) square(pcb);
    for (k = kb_caps) translate([each kbl([k[0], k[1]]), pcb_t + plate_h + 3])
        // Amiga two-tone: letters and numbers light, function row and wider keys darker
        color(k[2] > 1.1 || k[3] > 1.1 || k[4] || k[1] < 60 ? "#a9a395" : "#e4dfd2") keycap(k[2], k[3], k[4]);
}

module ghost_adapter() {
    color("royalblue") translate([each ad([99.95, 99.95]), ad_z]) cube([75.1, 29.59, pcb_t]);
    if (link == "db37") {
        color("silver") translate([ad([db_c, 0]).x - 69.3 / 2, rear_in - db_flange_t, ad_z + pcb_t]) cube([69.3, db_flange_t, 12.5]);
        color("silver") translate([ad([db_c, 0]).x - 26, rear_in - 1, db_z - 4.5]) cube([52, 7, 9]);
    } else
        color("dimgrey") translate([ad([din_c, 0]).x - 10.5, rear_in - 19, ad_z + pcb_t]) cube([21, 19, 19.5]);
}

module ghost_bar() color("silver") translate([kb([265, 0]).x - bar.x / 2, bar_y - bar.y / 2, floor_t + bar_lift]) cube(bar);

// ---- parts ----

module lid_print() translate([0, 0, lid_w0 + lid_t]) rotate([180, 0, 0])
    rotate([-kb_tilt, 0, 0]) translate([-kb_x0, -kb_y0, -kb_front_z]) children();

module left() intersection() { children(); translate([-1, -1, -1]) cube([split_x + 1, outer.y + 2, 200]); }
module right() intersection() { children(); translate([split_x, -1, -1]) cube([outer.x, outer.y + 2, 200]); }

if (part == "assembly") {
    color("#e6e0cf") tray();
    color("#d9d2bd") lid();
    ghost_keyboard();
    ghost_adapter();
    ghost_bar();
} else if (part == "exploded") {
    // halves pulled apart at the split, keyboard and lid lifted
    color("#e6e0cf") translate([-12, 0, 0]) left() tray();
    color("#cfc8b3") translate([12, 0, 0]) right() tray();
    ghost_bar();
    ghost_adapter();
    translate([0, 0, 45]) ghost_keyboard();
    translate([0, 0, 95]) {
        color("#d9d2bd") translate([-12, 0, 0]) left() lid();
        color("#c9c1aa") translate([12, 0, 0]) right() lid();
    }
} else if (part == "inside") {
    // tray with the bar and the rear board, no keyboard or lid
    color("#e6e0cf") tray();
    ghost_bar();
    ghost_adapter();
} else if (part == "tray_left") left() tray();
else if (part == "tray_right") right() tray();
// lids print top-down, top face flat on the bed
else if (part == "lid_left") lid_print() left() lid();
else if (part == "lid_right") lid_print() right() lid();
else if (part == "spacers") spacers();
