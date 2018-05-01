// The encoder
//
// This has 2 parts, the solid box at the bottom and the shaft

_width=11.7;
_hole_center=[_width*0.5,6.5,0];
_length=_hole_center.y+7.25;
_height=6.6;
_shaft_height=20;
_shaft_diameter=7;

// dimensions of "nub" thing that keeps it stiff against the top plate
_nub_dims=[2,1,1];
// translate to actual center of nub to make the drawing easy
_nub_center=[_width*0.5,0.5,_height+_nub_dims.z*0.5];

module _encoder_shaft()
{
translate(_hole_center) translate([0,0,_height)
    cylinder(r=_shaft_diameter*0.5,h=_height);
}

module _encoder_nub()
{
translate(_nub_center) cube(_nub_dims,center=true);
}

module encoder_mockup ()
{
cube([_width,_length,_height]);
_encoder_nub();
_encoder_shaft();
}

module encoder_void()
{
translate(0,0,1e-3)
    _encoder_shaft();
translate(0,0,1e-3)
    _encoder_nub();
}

// dimensions of box part, excluding shaft and nub
function encoder_dims()=[_width,_length,_height];
