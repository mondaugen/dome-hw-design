// The type A usb connector
//
// The goal is to hide the ugly bent metal by making a lip of plastic exactly as
// long as it.
// Then the connector should stick maybe halfway through the wall, hopefully
// that is close enough for the connector

_width=7.10;
_length=19.20;
_height=14.5;

_inner_width=5.7;
_inner_height=13.10;

module usb_mockup()
{
cube([_width,_length,_height]);
}

function usb_dims()=[_length,_width,_height]; 

