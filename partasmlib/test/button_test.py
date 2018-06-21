import button
import sys

but=button.button_t()
butshaft=button.button_shaft(but,inside=True,outside=True)
print(but.oscad_get_libs())
print(butshaft.oscad_get_libs())
print("$fn=50;")
print(but.oscad_draw_solid())
print(butshaft.oscad_draw_solid())
#print(super(type(circ),circ).oscad_draw_solid())
#dims=circ.get_dims()
#width=dims.x
#length=dims.y
#height=dims.z
#sys.stderr.write("width=%f length=%f height=%f\n" % (width,length,height))

