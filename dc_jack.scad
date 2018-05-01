// The DC Jack
//
// Has a part that must be inside the box and a part that protrudes
// see dc_jack_protrusion_y

_length=14.5;
_width=9;
_height=11;
_protrusion=7.7;

module dc_jack_draw_solid()
{
// Only cut out, no solid part
}

module dc_jack_draw_void()
{
cube([_width,_length,_height]);
}

module dc_jack_draw_mockup()
{
dc_jack_draw_void();
}

function dc_jack_dims()=[_width,_length,_height];

function dc_jack_protrusion_y(pcb_margin)_protrusion-pcb_margin;
