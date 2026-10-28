# Case

A low wedge case for an A1200KBv2 keyboard with the FFC ⇄ DB37 adapter or the DIN 5 encoder inside. It is a tray and a lid, each split left/right so every part fits a 256 mm bed. The model is `a1200kb-case.scad` (OpenSCAD); `export.sh` writes the STLs and a preview to `case/stl/`. The STLs there are exported from the current settings, which still include estimates (plate height, keycap height, bracket thickness; see `measurements.md`). Check those against your keyboard before printing, and re-export after changing any parameter. The keycaps in the renders come from `kbv2-keys.scad`, generated from the A1200KBv2 PCB.

Outside it is 467 × 196 mm, 22 mm tall at the front and 36 mm at the rear. The keyboard sits tilted 4° (rear up), and the lid follows it.

## How it goes together

- **Keyboard:** screws down through its own ten PCB holes, the same M3 screws that hold the plates and brackets, into heat-set inserts in tilted posts on the tray floor.
  - The left, right and lower KBv2 brackets use seven of those holes. Their posts stop a bracket's thickness short, so a keyboard with its brackets fitted drops straight in.
  - A keyboard without brackets takes the printed spacers instead (`part="spacers"`: four 3.4 mm, three 3.8 mm).
  - The three rear-row holes (x 155, 265, 375) carry no bracket and always land directly on their posts.
- **Stiffening bar:** a 400 × 10 × 3 mm aluminium flat stands on edge in slotted ribs across the floor, 70 mm behind the PCB's front edge. It bridges the left/right split and stays clear of the brackets, the posts and the underside of the PCB (5 mm).
- **Adapter:** sits flat on two posts (H1, H2) at the rear, with its J1 directly behind the keyboard's J1 so the FFC runs straight back. The DB37 comes through a D cut-out in the rear wall, with jackscrew holes at 63.5 mm.
- **Lid:** rests on the tray walls and is held by eight M3 screws from underneath into inserts in the lid. The keyboard opening follows the keycaps, with the A1200-style step at the top right where the function row stops. The three LED windows sit over the KBv2's power, floppy and disk LEDs, for the existing light pipes and shield.
- **Split:** the halves bolt together through blocks either side of the split (M3 × 12 with a nut): four in the tray, two in the lid.

## Hardware

- M3 heat-set inserts (4.0 mm hole, up to 6.5 mm long): 10 keyboard, 2 adapter, 8 lid
- M3 × 12 screws and nuts: 6, for the split
- M3 screws, lid to tray: 8. Their length depends on the final post heights; the slicer shows it
- 4-40 jackscrews or hex posts for the DB37
- 10 × 3 mm aluminium flat bar, 400 mm
- 12 mm rubber feet: 4, in the floor recesses

## Printing

The tray halves print floor down, and the lid halves print top down. Use `export.sh` rather than exporting from the GUI: it puts each lid half on its top face, since the lid is tilted in the model.

## Not yet confirmed

Everything taken from the KiCad and STL files is exact: PCB outline and holes, key positions, LED positions, bracket strips, adapter. The values below are estimates, marked in the `.scad` file. Fill in `measurements.md` once the keyboard is built, then update them:

- `plate_h`: PCB top to plate top; sets the lid height
- `key_h`: keycap height, used only for the preview and the clearance check
- `side_bracket_t`, `lower_bracket_t`: confirm against the printed brackets
- Light pipe exits: the windows assume straight above each LED
- `db_flange_t`, `db_cut`: trial-fit the DB37 socket in the rear wall
