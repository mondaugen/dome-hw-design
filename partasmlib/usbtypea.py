import domepartconfig as dpc
import partasm as pa

# To hide the ugly end, we cut a hole that is slightly smaller
width=7.10
length=19.2
height=14.5
inner_width=5.7
inner_height=13.1
# The distance from the edge of the PCB on which this part sits and its back.
# This is because the part hangs off the edge (so it can protrude out the side
# of the case)
lead_pcb_edge_gap=2
min_inset=length-11+lead_pcb_edge_gap
default_overhang=length-min_inset
hole_depth=100

class usbtypea_t(pa.cube_t):
    """ 
    Also basically a cube but cuts a hole for the USB protrusion.
    Does this in a interesting way to mask the ugly finish of the USB: cuts a
    hole equal to the width and height so that the USB jack could fit where that
    is. Then it cuts a hole in front of this with the inner width and height.
    This is so that, if cutting into a wall, there is a little flap that covers
    the ugly edges of the USB port. To control the thickness of this flap, play
    with the wall thickness and the overhang parameter.
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
        trans_male=trans+pa.point_t((width-inner_width)*0.5,0,(height-inner_height)*0.5)
        # First cut out for the USB jack, then cut the hole for the male part
        # access
        return("""
    translate([{trans.x},{trans.y},{trans.z}])
    cube([{voiddims[0]},{voiddims[1]},{voiddims[2]}]);
    translate([{trans_male.x},{trans_male.y},{trans_male.z}])
    cube([{malevoiddims[0]},{malevoiddims[1]},{malevoiddims[2]}]);
    """.format(trans=trans,voiddims=[width,length-self.inset,height],
        trans_male=trans_male,
        malevoiddims=[inner_width,hole_depth,inner_height]))
