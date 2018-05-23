# A push button
# Uses cube to get the "hull" of the shape but the drawing is a bit more
# refined.

width=6
length=6
height=4.3
bottom_height=3.45
button_diameter=3.5

class button_t(pa.cube_t):
    """ 
    Basically a cube but draws the top of the button too.
    """
    def __init__(self,coords=(0,0,0)):
        pa.cube_t.__init__(self,coords,dims=(width,length,height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()
        dims=self.get_dims()
        trans_centre=[trans.x+dims.x*0.5,trans.y+dims.y*0.5,0]
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
            height=height)
