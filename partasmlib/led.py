# An led
# Uses cube to get the "hull" of the shape but the drawing is a bit more
# refined.

import partasm as pa

width=1.6
length=1.6
height=.35
bottom_height=.18
inner_width=.8

class led_t(pa.cube_t):
    """ 
    Basically a cube.
    """
    def __init__(self,coords=(0,0,0)):
        pa.cube_t.__init__(self,coords,dims=(width,length,height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()
        dims=self.get_dims()
        inner_trans_y=(width-inner_width)*0.5
        top_height=height-bottom_height
        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        cube([{dims.x},{dims.y},{bottom_height}]);
        translate([{trans.x},{trans.y},{trans.z}])
        translate([0,{inner_trans_y},{bottom_height}])
        cube([{dims.x},{inner_width},{top_height}]);
        """.format(trans=trans,
            dims=dims,
            inner_trans_y=inner_trans_y,
            bottom_height=bottom_height,
            inner_width=inner_width,
            top_height=top_height))
