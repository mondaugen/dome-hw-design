// The keys that press the buttons
//
// This has a few parts. There's the actual key, there's its hole and there's
// shaft that guides the key down to press the button
//
// The length of the shaft should be no longer than the distance from the inside
// top wall edge to the top of the box. This also implies that the shaft should
// be bigger than the button's shaft.
//

use <common.scad>;
use <common_dims.scad>;
use <button.scad>;
//use <rounded_polygon.scad>;

_width=20;
_length=20;
_key_shaft_dist=0.5;
// Thickness of shaft wall
_wall=wall_thickness();

module _button_key_guides (height)
{
translate([-_width*0.5-wall_thickness(),-wall_thickness()*0.5,0])
    cube([_width+wall_thickness()*2,wall_thickness(),height]);
translate([-wall_thickness()*0.5,-_length*0.5-wall_thickness(),0])
    cube([wall_thickness(),_length+wall_thickness()*2,height]);
}

// Height is distance between PCB surface and inside wall
// coordinates are relative to center of button's bottom
module button_key_solid (height)
{
_shaft_dent_height=0.3;
_button_dims=button_dims();

// make sure that the bottom of the button doesn't go past the top of the button
// bottom of key is just slightly below top of button's cylinder
_key_bottom_z=_button_dims.z-_shaft_dent_height;
domeassert(_key_bottom_z>button_box_height(),"Bottom of key past button box!");
_key_height=height-(_button_dims.z-_shaft_dent_height)+wall_thickness();

difference () {
// draw key box
union () {
translate([0,0,_key_bottom_z])
    rounded_square([0,0,_key_height*0.5],[_width-2*_key_shaft_dist,_length-2*_key_shaft_dist,_key_height],button_corner_r()-_key_shaft_dist);
translate([0,0,_key_bottom_z])
    _button_key_guides(_key_height-wall_thickness());
}
// subtract out dent for top of button
translate([0,0,_key_bottom_z-1e-2])
    cylinder(r=button_shaft_diameter()*0.5,h=_shaft_dent_height);
}

}

// is as for button_key_solid
module button_key_shaft_solid (height,text="A")
{
difference () {
rounded_shaft([0,0,height*0.5],[_width,_length,height],
button_corner_r(),wall_thickness());
translate([0,0,-5e-3])
_button_key_guides(height+1e-2);
}
}

$fn=30;

// key test
button_key_solid(10);
*button_key_shaft_solid(10);
