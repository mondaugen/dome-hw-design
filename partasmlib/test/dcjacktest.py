# Include parent directory in python path
import partasm as pa
import midijack as mj
import dcjack as dj
import domepartconfig as dpc

wallgap=dpc.wall_thickness

midi_jack_out=mj.midi_jack_t(hole_relative_to_bottom=False)
midi_jack_in=mj.midi_jack_t(hole_relative_to_bottom=False)
dc_jack=dj.dc_jack_t(overhang=wallgap+1)

parts=[ midi_jack_out ]
parts=pa.stick_on_part(parts,midi_jack_in,'e',('','+','+'),False)
parts=pa.stick_on_part(parts,dc_jack,'e',('','+','+'),False)

co,di=pa.parts_hull(parts)

back_wall= pa.cube_t(coords=(co-pa.point_t(wallgap,0,wallgap)).as_tuple(),
    dims=(di.x+2*wallgap,wallgap,di.z+2*wallgap))

parts=pa.stick_on_part(parts,back_wall,'n',('-','','-'),True)

# The circuit
print('color("MediumSeaGreen") {')
print("difference () {")
print("union () {")
for p in [midi_jack_in,midi_jack_out,dc_jack]:
    print(p.oscad_draw_solid())
print("}")
print("union () {")
print("}")
print("}")
print("}")

# The box
print('color("Snow") {')
print("difference () {")
print("union () {")
for p in [back_wall]:
    print(p.oscad_draw_solid())
print("}")
print("union () {")
for p in parts:
    print(p.oscad_draw_void())
print("}")
print("}")
print("}")

