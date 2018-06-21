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
# extra space that button key takes up, the same amount added to width and
# length
key_extra=5##15-width
# space between shaft and button
button_gap=0.5
# space between key rail and shaft rail
key_rail_gap=0.5
# the thickness of the text. If positive number it will be extruded, if
# negative, embossed
keytextthickness=1

class button_t(pa.cube_t):
    """ 
    Basically a cube but draws the top of the button too.
    """
    def __init__(self,coords=(0,0,0)):
        # We define our own gap because we don't want a gap in the z dimension
        xspace=2*(button_gap+wall_thickness+key_extra)
        pa.cube_t.__init__(self,
                coords,
                dims=(xspace+width,
                    xspace+length,height),gap=0)

    def oscad_draw_solid(self):
        trans=self.get_trans_to_solid()+pa.point_t(1.,1.,0)*(wall_thickness+button_gap+key_extra)
        dims=pa.point_t(width,length,height)
        trans_centre=[dims.x*0.5,dims.y*0.5,0]
        top_height=height-bottom_height
#        return ""
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

    def oscad_draw_void(self):
        return ""

class button_shaft(pa.cube_t):
    """
    Takes a button as an argument and a height and makes a shaft that surrounds
    the button as well as a key to travel in the shaft and hit the button. The
    height is the distance from the top of the button to the bottom of the wall on
    the top of the case.
    keyheight is the height of the key, which is generally greater than height
    because height is distance to bottom of top wall. If not specified, defaults
    to the height plus the thickness of the walls.
    keytext will be printed on the key if not none (default)
    """
    def __init__(self,but,height=5,inside=False,outside=True,keyheight=None,
            keytext=None,font="Sans",fontsize=length*0.5):
        """
        If inside is True, draws inside, useful for printing the actual button
        key.
        """
        if not keyheight:
            # If keyheight not specified, defaults to given height plus the
            # thickness of the wall on the top
            self.keyheight = height + dpc.wall_thickness
        else:
            self.keyheight = keyheight
        self.inside=inside
        self.outside=outside
        self.height = height
        self.button = but
        self.keytext=keytext
        self.font=font
        self.fontsize=fontsize
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
        s=""
        if self.inside:
            s_=""
            # Draw key
            s_+="""
            translate([{trans.x},{trans.y},{trans.z}])
            difference () {{
            union () {{
            rounded_key(
            [{local_trans.x},{local_trans.y},{local_trans.z}],
            [{key_dims.x},{key_dims.y},{key_dims.z}],
            {corner_radius},
            {wall_thickness});
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
            union () {{
            """
            if self.keytext:
                s_+="""
                translate([{key_top_trans.x},{key_top_trans.y},{key_top_trans.z}])
                linear_extrude ({keytextthickness}) {{
                text("{keytext}",font="{font}",size={fontsize},halign="center",valign="center");
                }}
            """
            s_+="""
            }}
            }}
            """
            key_gap=wall_thickness+button_gap
            key_rail_thickness=shaft_thickness-key_rail_gap
            s += s_.format(
            trans=trans,
            local_trans=pa.point_t(dims.x*0.5,dims.y*0.5,self.button.get_dims().z+self.keyheight*0.5),
            key_dims=pa.point_t(
                width+key_extra,
                length+key_extra,
                self.keyheight),
            corner_radius=corner_radius,
            trans_e=pa.point_t(key_gap-key_rail_thickness,dims.y*0.5-key_rail_thickness*0.5,height),
            trans_w=pa.point_t(key_gap+width,dims.y*0.5-key_rail_thickness*0.5,height),
            trans_s=pa.point_t(dims.x*0.5-key_rail_thickness*0.5,key_gap-key_rail_thickness,height),
            trans_n=pa.point_t(dims.x*0.5-key_rail_thickness*0.5,key_gap+length,height),
            rail=pa.point_t(key_rail_thickness,key_rail_thickness,height),
            key_top_trans=pa.point_t(dims.x*0.5,dims.y*0.5,
                self.button.get_dims().z+self.keyheight-keytextthickness),
            keytextthickness=keytextthickness,
            keytext=self.keytext,
            font=self.font,
            fontsize=self.fontsize,
            wall_thickness=wall_thickness
            )
        # Draw shaft and rails in which key slides
        if self.outside:
            s_ = """
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
                )
            s+=s_
        return s

    def oscad_draw_void(self):
        if not self.inside:
            return pa.cube_t.oscad_draw_void(self)
        else:
            return ""
    
    def oscad_get_libs(self):
        return("use <libs/rounded_shaft.scad>")


