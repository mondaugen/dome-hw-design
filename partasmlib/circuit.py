# The collection of all the electronic parts and their layout
# 
# Also this can be queried for the voids so that it can cut a box placed around
# the circuit if need be

import partasm as pa
import midijack as mj
import dcjack as dj
import usbtypea as uta
import domepartconfig as dpc
import led_array as leda

pcb_thickness=1.575
led_array={
        "n_rows":4,
        "n_cols":10
        }
wallgap=dpc.wall_thickness

class circuit_t(pa.cube_t):

    def __init__(self):
        self.midi_jack_out=mj.midi_jack_t(hole_relative_to_bottom=False)
        self.midi_jack_in=mj.midi_jack_t(hole_relative_to_bottom=False)
        self.dc_jack=dj.dc_jack_t(overhang=wallgap+1)
        self.usb_a=uta.usbtypea_t(overhang=wallgap-1)
        self.led_array=leda.led_array_t(
                nrows=led_array['n_rows'],
                ncols=led_array['n_cols'],
                gapx=2,
                gapy=2)

        back_wall_parts=[ self.midi_jack_out ]
        back_wall_parts=pa.stick_on_part(back_wall_parts,self.midi_jack_in,'e',('','+','+'),False)
        back_wall_parts=pa.stick_on_part(back_wall_parts,self.usb_a,'e',('','+','+'),False)
        back_wall_parts=pa.stick_on_part(back_wall_parts,self.dc_jack,'e',('','+','+'),False)
        # Led array starts in front of and above back_wall_parts
        self.parts=pa.stick_on_part(back_wall_parts,
                self.led_array,
                's',('-','','+'),True)
        self.led_array.translate((0,0,self.led_array.get_dims().z+pcb_thickness))

    def oscad_draw_solid(self):
        s=""
        for p in self.parts:
            s += p.oscad_draw_solid() + "\n"
            #s += super(type(p),p).oscad_draw_solid() + "\n"
        
        return s
