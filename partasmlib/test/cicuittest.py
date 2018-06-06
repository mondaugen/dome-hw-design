import circuit
import sys

circ=circuit.circuit_t()
print(circ.oscad_draw_solid())
#print(super(type(circ),circ).oscad_draw_solid())
dims=circ.get_dims()
width=dims.x
length=dims.y
height=dims.z
sys.stderr.write("width=%f length=%f height=%f\n" % (width,length,height))
