# Include parent directory in python path
import partasm as pa
import midijack as mj
import dcjack as dj
import usbtypea as uta
import domepartconfig as dpc

wallgap=dpc.wall_thickness

midi_jack_out=mj.midi_jack_t(hole_relative_to_bottom=False)
midi_jack_in=mj.midi_jack_t(hole_relative_to_bottom=False)
dc_jack=dj.dc_jack_t(overhang=wallgap+1)
usb_a=uta.usbtypea_t(overhang=wallgap-1)

parts=[ midi_jack_out ]
parts=pa.stick_on_part(parts,midi_jack_in,'e',('','+','+'),False)
parts=pa.stick_on_part(parts,usb_a,'e',('','+','+'),False)
parts=pa.stick_on_part(parts,dc_jack,'e',('','+','+'),False)

co,di=pa.parts_hull(parts)

back_wall= pa.cube_t(dims=(di.x+2*wallgap,wallgap,di.z+2*wallgap))

parts=pa.stick_on_part(parts,back_wall,'n',('-','','-'),False)

# The circuit
#print('color("MediumSeaGreen") {')
#print("difference () {")
#print("union () {")
#for p in [midi_jack_in,midi_jack_out,dc_jack,usb_a]:
#    print(p.oscad_draw_solid())
##    print(super(type(p),p).oscad_draw_solid())
#print("}")
#print("union () {")
#print("}")
#print("}")
#print("}")

#print(cube_hull.oscad_draw_solid())

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

