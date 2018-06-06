# A push button
# Uses cube to get the "hull" of the shape but the drawing is a bit more
# refined.

import partasm as pa
import domepartconfig as dpc
import sys

width=6
length=6
height=4.3
bottom_height=3.45
button_diameter=3.5
button_gap=dpc.wall_thickness

class button_t(pa.cube_t):
    """ 
    Basically a cube but draws the top of the button too.
    """
    def __init__(self,coords=(0,0,0)):
        # We define our own gap because we don't want a gap in the z dimension
        pa.cube_t.__init__(self,
                coords,
                dims=(2*button_gap+width,2*button_gap+length,height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()+pa.point_t(button_gap,button_gap,0)
        dims=pa.point_t(width,length,height)
        trans_centre=[dims.x*0.5,dims.y*0.5,0]
        top_height=height-bottom_height
        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        cube([{dims.x},{dims.y},{bottom_height}]);
        translate([{trans.x},{trans.y},{trans.z}])
        translate([{trans_centre[0]},{trans_centre[1]},{trans_centre[2]}])
        cylinder(r={button_rad},h={height});
        """.format(trans=trans,
            dims=dims,
            trans_centre=trans_centre,
            bottom_height=bottom_height,
            button_rad=button_diameter*0.5,
            height=height))

class button_shaft(pa.cube_t):
    """
    Takes a button as an argument and a height and makes a shaft that surrounds
    the button as well as a key to travel in the shaft and hit the button. The
    height is the distance from the top of the button to the top of the wall on
    the top of the case.
    """
    def __init__(self,but,height=5):
        self.height = height
        self.button = but
        dims = but.get_dims()
        dims.z += self.height
        pa.cube_t.__init__(self,
                but.translation.as_tuple(),
                dims.as_tuple(),gap=0)
    
    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()
        dims=self.get_dims()
        walltransx=dims.x-button_gap
        walltransy=dims.y-button_gap

        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        union () {{
        cube([{button_gap},{dims.y},{height}]);
        cube([{dims.x},{button_gap},{height}]);
        }};
        translate([{trans.x},{trans.y},{trans.z}])
        translate([{walltransx},0,0])
        cube([{button_gap},{dims.y},{height}]);
        translate([{trans.x},{trans.y},{trans.z}])
        translate([0,{walltransy},0])
        cube([{dims.x},{button_gap},{height}]);
        """.format(
            trans=trans,
            button_gap=button_gap,
            height=dims.z,
            dims=dims,
            walltransx=walltransx,
            walltransy=walltransy))



