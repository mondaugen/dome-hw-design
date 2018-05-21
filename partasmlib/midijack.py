import domepartconfig as dpc
import partasm as pa

width=20
length=13.2
height=21.1
hole_centre_height=10
# Slightly more than the part's actual hole diameter to take in account the
# plastic on MIDI cable jacks
hole_diameter=18
# The depth of the hole. This can be a big number because nothing should be in
# front of the MIDI jack hole (how else would you get the plug in)
hole_depth=100

class midi_jack_t(pa.cube_t):
    """ 
    Basically a cube but cuts a hole where the MIDI jack hole should be.  
    """
    def __init__(self,coords=(0,0,0),hole_relative_to_bottom=True):
        gapdict={'n':0,'s':dpc.gap,'e':dpc.gap,'w':dpc.gap,'t':0,'b':0}
        pa.cube_t.__init__(self,coords,dims=(width,length,height),gap=gapdict)
        # If set to false, hole will be relative to the top
        self.hole_relative_to_bottom=hole_relative_to_bottom
    def get_trans_to_hole_centre(self):
        if self.hole_relative_to_bottom:
            return pa.point_t(width*0.5,length,hole_centre_height)
        else:
            return pa.point_t(width*0.5,length,height-hole_centre_height)

    def oscad_draw_void(self):
        trans=self.get_trans_to_solid() + self.get_trans_to_hole_centre()
        hole_rad=hole_diameter*0.5
        return("""
    translate([{trans.x},{trans.y},{trans.z}])
    rotate([-90,0,0])
    cylinder(r={hole_rad},h={hole_depth});
    """.format(trans=trans,hole_rad=hole_rad,hole_depth=hole_depth))


