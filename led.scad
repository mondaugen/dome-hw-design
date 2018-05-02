// The LEDs
//
// The LED array needs holes taller and larger than these
// Also it should be determined what is the tallest object on the top of the
// board in order to determine the distance from the PCB to the inside top wall
//

_width=1.6;
_length=1.6;
_height=.35;

_inner_width=.8;
_inner_height=.18;

module led_mockup ()
{
cube([_width,_length,_inner_height]);
translate([(_width-_inner_width)*0.5,0,0])
    cube([_inner_width,_length,_height]);
}

function led_dims()=[_width,_length,_height];

