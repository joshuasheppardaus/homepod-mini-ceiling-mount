# HomePod mini Ceiling Mount — Open Hardware Prototype

**Release:** Revision 7 prototype package  
**Status:** Experimental / fit-test prototype — not load-rated  
**Units:** millimetres (mm)  
**Parametric source:** OpenSCAD

This community project explores a printable ceiling mount for an Apple HomePod mini. The intent is to let people study the design, print the parts, test fit and assembly, report findings, and contribute improvements.

> **Important safety notice:** This is an experimental prototype. It has not been validated for overhead use, and no safe working load is specified. A successful STL render or watertight mesh does not establish mechanical strength or safe operation. Do not install it above people, pets, or valuable property. Do not rely on it as a permanent ceiling mount unless the complete design, fasteners, substrate, printed material, print orientation, locking mechanism, and load path have been independently assessed and tested by a competent person.

Apple and HomePod are trademarks of Apple Inc. This is an independent community design and is not affiliated with, endorsed by, or certified by Apple.

## Package contents

- `source/homepod_ceiling_mount.scad` — editable parametric OpenSCAD design.
- `stl/ceiling_plate.stl` — ceiling plate with keyhole/bayonet tracks.
- `stl/upper_ring.stl` — upper ring and bayonet lugs.
- `stl/lower_ring.stl` — speaker support ring.
- `stl/support_arm.stl` — one support arm; print three.
- `stl/cable_clip.stl` — cable clip; print as needed and test fit to the actual cable.
- `stl/locking_pin.stl` — one pin; print six for the current assembly concept.
- `docs/PRINTING_AND_ASSEMBLY.md` — first-print checklist and assembly notes.
- `docs/TEST_LOG_TEMPLATE.md` — suggested repeatable test record.
- `docs/REVISION_HISTORY.md` — known changes and validation status.
- `CONTRIBUTING.md` — how to share useful improvements.
- `LICENSE.txt` — licence identification and link to the official licence text.

## Quick start

1. Read the safety note and `docs/PRINTING_AND_ASSEMBLY.md` before printing.
2. Print the six unique parts using your own printer/material profile; start with a low-cost fit-test material.
3. Print three support arms and six locking pins.
4. Test the bayonet engagement and arm joints **on a bench**, not overhead.
5. Record printer, material, slicer settings, dimensions, fit, and failures in `docs/TEST_LOG_TEMPLATE.md`.
6. Share your observations and any modified source with a clear revision number and change notes.

## Editing the model

Open `source/homepod_ceiling_mount.scad` in OpenSCAD. The `part` selector can be set to:

`"assembled"`, `"ceiling_plate"`, `"upper_ring"`, `"lower_ring"`, `"arm"`, `"cable_clip"`, `"locking_pin"`, or `"layout"`.

The current default is `part = "assembled"`. For an STL export, select the individual part, render with **F6**, then use **File → Export → Export as STL**. Export and inspect one part at a time.

## Current validation status

The six distributed STL files were checked at mesh level for watertightness and single connected components. This is a geometry-file check only. The assembled model's dimensional fit, bayonet lock, joint strength, print anisotropy, creep, fatigue, ceiling attachment, and safe working load have **not** been validated. Physical prototype feedback is expected to drive future revisions.

## Open-source licence

The design source and associated hardware files are intended to be released under **CERN-OHL-S-2.0** (strongly reciprocal). See `LICENSE.txt` for the official licence reference. Contributions distributed as modified source should retain applicable notices and follow the licence terms.
