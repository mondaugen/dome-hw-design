// The button
//
// see "key" for the part that goes on top of the button

_width=6;
_length=6;
_total_height=4.3;
_box_height=3.45;
_center=[_width*0.5,_length*0.5,0];
_button_diameter=3.5;

module _button_shaft ()
{
translate(_center)
cylinder(r=_button_diameter*0.5,h=_total_height);
}

module _button_box ()
{
cube([_width,_length,_box_height]);
}

module button_mockup ()
{
_button_box();
_button_shaft();
}

function button_dims()=[_width,_length,_total_height];
function button_shaft_diameter()=_button_diameter;
// Height of box part (without protruding button)
function button_box_height()=_box_height;

