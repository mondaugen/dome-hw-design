# The collection of all the electronic parts and their layout
# 
# Also this can be queried for the voids so that it can cut a box placed around
# the circuit if need be

import sys
import partasm as pa
import midijack as mj
import dcjack as dj
import usbtypea as uta
import domepartconfig as dpc
import led_array as leda
import encoder as enc
import top_circuit as topcirc
import back_wall_parts as bwp

pcb_thickness=dpc.pcb_thickness
wallgap=dpc.wall_thickness

class circuit_t(pa.cube_t):

    def __init__(self):
        #self.midi_jack_out=mj.midi_jack_t(hole_relative_to_bottom=False)
        #self.midi_jack_in=mj.midi_jack_t(hole_relative_to_bottom=False)
        #self.dc_jack=dj.dc_jack_t(overhang=wallgap+1)
        #self.usb_a=uta.usbtypea_t(overhang=wallgap-1)

        #back_wall_parts=[ self.midi_jack_out ]
        #back_wall_parts=pa.stick_on_part(back_wall_parts,self.midi_jack_in,'e',('','+','+'),False)
        #back_wall_parts=pa.stick_on_part(back_wall_parts,self.usb_a,'e',('','+','+'),False)
        #back_wall_parts=pa.stick_on_part(back_wall_parts,self.dc_jack,'e',('','+','+'),False)
        self.back_wall_parts = bwp.back_wall_parts_t()
        self.top_circuit=topcirc.top_circuit_t(ideal_width=self.back_wall_parts.get_dims().x)
        self.parts=pa.stick_on_part([self.back_wall_parts],
                self.top_circuit,
                's',('-','','+'),False)
        self.top_circuit.translate((0,0,self.top_circuit.get_dims().z+pcb_thickness))
        #self.parts=[self.top_circuit]

#        # Led array starts in front of and above back_wall_parts
#        self.parts=pa.stick_on_part(back_wall_parts,
#                self.led_array,
#                's',('-','','+'),True)
#        # Move them above pcb
#        self.led_array.translate((0,0,self.led_array.get_dims().z+pcb_thickness))
#        self.top_encoder.translate((0,0,self.top_encoder.get_dims().z+pcb_thickness))

    def oscad_draw_solid(self):
        s=""
        for p in self.parts:
            #sys.stderr.write(str(p.__class__)+'\n')
            s += p.oscad_draw_solid() + "\n"
            #s += super(type(p),p).oscad_draw_solid() + "\n"
        
        return s
