import partasm as pa
import midijack as mj
import dcjack as dj
import usbtypea as uta
import domepartconfig as dpc

wallgap=dpc.wall_thickness

class back_wall_parts_t(pa.cube_t):

    def __init__(self):

        self.midi_jack_out=mj.midi_jack_t(hole_relative_to_bottom=False)
        self.midi_jack_in=mj.midi_jack_t(hole_relative_to_bottom=False)
        self.dc_jack=dj.dc_jack_t(overhang=wallgap+1)
        self.usb_a=uta.usbtypea_t(overhang=wallgap-1)

        self.parts=[ self.midi_jack_out ]
        self.parts=pa.stick_on_part(self.parts,self.midi_jack_in,'e',('','+','+'),False)
        self.parts=pa.stick_on_part(self.parts,self.usb_a,'e',('','+','+'),False)
        self.parts=pa.stick_on_part(self.parts,self.dc_jack,'e',('','+','+'),False)

        co,dim=pa.parts_hull(self.parts)
        pa.cube_t.__init__(self,coords=co.as_tuple(),dims=dim.as_tuple())

    def oscad_draw_solid(self):
        s=""
        for p in self.parts:
            s += p.oscad_draw_solid() + "\n"
        
        return s

    def translate(self,coords):
        pa.cube_t.translate(self,coords)
        for l in self.parts:
            l.translate(coords)
