import partasm as pa
import domepartconfig as dpc

# A push button
# Uses cube to get the "hull" of the shape but the drawing is a bit more
# refined.

width=11.7
shaft_center_y=6.5
length=shaft_center_y+7.25
height=20
bottom_height=6.6
shaft_diameter=7
shaft_gap=1

class encoder_t(pa.cube_t):
    """ 
    Basically a cube but also cuts the hole for the encoder
    """
    def __init__(self,coords=(0,0,0)):
        pa.cube_t.__init__(self,coords,dims=(width,length,bottom_height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()
        dims=self.get_dims()
        trans_centre=[dims.x*0.5,shaft_center_y,0]
        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        cube([{dims.x},{dims.y},{bottom_height}]);
        translate([{trans.x},{trans.y},{trans.z}])
        translate([{trans_centre[0]},{trans_centre[1]},{trans_centre[2]}])
        cylinder(r={shaft_radius},h={height});
        """.format(trans=trans,
            dims=dims,
            trans_centre=trans_centre,
            bottom_height=bottom_height,
            shaft_radius=shaft_diameter*0.5,
            height=height))

    def oscad_draw_void(self):
        trans=self.get_trans_to_solid()+pa.point_t(dims.x*0.5,shaft_center_y,0)
        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        cylinder(r={shaft_radius},h={height});
        """.format(trans=trans,shaft_radius=shaft_diameter*0.5+shaft_gap,height=height))
