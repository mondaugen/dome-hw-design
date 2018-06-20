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
corner_radius=0.5
# thickness of shaft walls
wall_thickness=dpc.wall_thickness
# space between shaft and button
button_gap=0.5

class button_t(pa.cube_t):
    """ 
    Basically a cube but draws the top of the button too.
    """
    def __init__(self,coords=(0,0,0)):
        # We define our own gap because we don't want a gap in the z dimension
        xspace=2*(button_gap+wall_thickness)
        pa.cube_t.__init__(self,
                coords,
                dims=(xspace+width,
                    xspace+length,height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()+pa.point_t(1.,1.,0)*(wall_thickness+button_gap)
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
    height is the distance from the top of the button to the bottom of the wall on
    the top of the case.
    """
    def __init__(self,but,height=5,inside=False):
        """
        If inside is True, draws inside, useful for printing the actual button
        key.
        """
        self.inside=inside
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
        local_trans=dims*0.5;
        xspacegap=2*wall_thickness
        inside_dims = dims - pa.point_t(xspacegap,xspacegap,0)
        shaft_thickness=wall_thickness*0.5
        if self.inside:
            return ""
        # Draw shaft and rails in which key slides
        return("""
        translate([{trans.x},{trans.y},{trans.z}])
        difference () {{
        rounded_shaft(
        [{local_trans.x},{local_trans.y},{local_trans.z}],
        [{inside_dims.x},{inside_dims.y},{inside_dims.z}],
        {corner_radius},
        {wall_thickness}
        );
        union () {{
        for(trans_=[
        [{trans_e.x},{trans_e.y},{trans_e.z}],
        [{trans_w.x},{trans_w.y},{trans_w.z}],
        [{trans_s.x},{trans_s.y},{trans_s.z}],
        [{trans_n.x},{trans_n.y},{trans_n.z}]
        ]) {{
        translate(trans_)
        cube([{rail.x},{rail.y},{rail.z}]);
        }}
        }}
        }}
        """.format(
            trans=trans,
            local_trans=local_trans,
            inside_dims=inside_dims,
            corner_radius=corner_radius,
            wall_thickness=wall_thickness,
            trans_e=pa.point_t(wall_thickness-shaft_thickness,dims.y*0.5-shaft_thickness*0.5,0),
            trans_w=pa.point_t(wall_thickness+inside_dims.x,dims.y*0.5-shaft_thickness*0.5,0),
            trans_s=pa.point_t(dims.x*0.5-shaft_thickness*0.5,wall_thickness-shaft_thickness,0),
            trans_n=pa.point_t(dims.x*0.5-shaft_thickness*0.5,wall_thickness+inside_dims.y,0),
            rail=pa.point_t(shaft_thickness,shaft_thickness,inside_dims.z)
            ))
    
    def oscad_get_libs(self):
        return("use <libs/rounded_shaft.scad>")


