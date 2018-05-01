// The midi jack

_width=20;
_length=15.8;
_height=21.1;
_hole_center=[10,0,10];
_hole_diameter=15; // should double-check

module midi_jack_mockup()
{
cube([_width,_length,_height]);
}

// relative to bottom-left-hand coordinates of actual connector
// h is length of cylinder
module midi_jack_void(h)
{
    translate([0,_length,0]) translate(_hole_center)
        rotate([-90,0,0]) cylinder(r=_hole_diameter*0.5,h=h);
}

function midi_jack_dims()=[_width,_length,_height];
