import partasm as pa
import sys

parts=[
    pa.cube_t(),
    pa.cube_t(coords=(1,0,0)),
    pa.cube_t(coords=(1,1,0),dims=(1,0.5,1)),
]

points=[]
for p in parts:
    points += p.get_rect_points()

ep=pa.extreme_points(points)
mi,ma=ep
sys.stderr.write("min\n")
for m in mi:
    sys.stderr.write(m.__string__()+'\n')
sys.stderr.write("max\n")
for m in ma:
    sys.stderr.write(m.__string__()+'\n')

parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.5,0.25,0.5)),
        'e',('','+','+'),False)
parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.5,0.25,0.25)),
        'w',('','+','-'),False)
parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.5,0.25,0.25)),
        'b',('+','+',''),False)
parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.75,0.25,0.25),gap=0.2),
        't',('-','+',''),False)
parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.75,0.25,0.25),gap=0.3),
        'n',('-','','-'),False)
parts=pa.stick_on_part(parts,pa.cube_t(dims=(0.75,0.25,0.25),gap=0.1),
        'w',('','+','-'),False)

for p in parts:
    print(p.oscad_draw_solid())
#print(parts[-1].oscad_draw())
