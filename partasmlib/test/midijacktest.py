# Include parent directory in python path
import partasm as pa
import midijack as mj

parts=[
        mj.midi_jack_t(hole_relative_to_bottom=False)
]
parts=pa.stick_on_part(parts,mj.midi_jack_t(hole_relative_to_bottom=False),'e',('','+','-'),False)
co,di=pa.parts_hull(parts)
parts=pa.stick_on_part(parts,pa.cube_t(coords=co.as_tuple(),
    dims=(di.x,5,di.z)),'n',('-','','-'),True)

print("difference () {")
print("union () {")
for p in parts:
    print(p.oscad_draw_solid())
print("}")
print("union () {")
for p in parts:
    print(p.oscad_draw_void())
print("}")
print("}")
