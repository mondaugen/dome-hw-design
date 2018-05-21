import domepartconfig as dpc
import partasm as pa

width=9
length=14.5
height=11
# The distance from the edge of the PCB on which this part sits and its back.
# This is because the part hangs off the edge (so it can protrude out the side
# of the case)
lead_pcb_edge_gap=2
min_inset=length-7.7+lead_pcb_edge_gap
default_overhang=length-min_inset
hole_depth=100

class dc_jack_t(pa.cube_t):
    """ 
    Basically a cube but cuts a square hole where the DC jack protrudes.  
    overhang is how far the DC jack protrudes from the PCB.
    """
    def __init__(self,coords=(0,0,0),overhang=default_overhang):
        gapdict={'n':0,'s':dpc.gap,'e':dpc.gap,'w':dpc.gap,'t':0,'b':0}
        # This is the cube as far as the stick_on_part and extreme_points
        # algorithms are concerned, drawing uses different dimensions as the
        # part is supposed to hang off the side
        self.inset=length-overhang
        if self.inset < min_inset:
            raise Exception("Too much overhang, minimum inset exceeded.")
        pa.cube_t.__init__(self,coords,dims=(width,self.inset,height),gap=gapdict)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()
        return("""
    translate([{trans.x},{trans.y},{trans.z}])
    cube([{soliddims[0]},{soliddims[1]},{soliddims[2]}]);
    """.format(trans=trans,soliddims=[width,length,height]))

    def oscad_draw_void(self):
        trans=self.get_trans_to_solid()+pa.point_t(0,self.inset,0)
        return("""
    translate([{trans.x},{trans.y},{trans.z}])
    cube([{voiddims[0]},{voiddims[1]},{voiddims[2]}]);
    """.format(trans=trans,voiddims=[width,hole_depth,height]))
