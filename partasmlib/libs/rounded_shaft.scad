module domeassert(x,msg)
{ 
if (!x) {
echo("this shit failed:", msg);
}
}

module rounded_square(
    center, // x,y,z coordinates of center
    dims, // width (x dimension), length (y dimension), height (z dimension)
    corner_radius, // the radius of the corners
) {
    // the corners
    corners_x=[-(dims[0]*0.5-corner_radius),(dims[0]*0.5-corner_radius)];
    corners_y=[-(dims[1]*0.5-corner_radius),(dims[1]*0.5-corner_radius)];
    translate(center) {
        // Draw the corners
        hull () {
        for (x=corners_x) {
            for(y=corners_y) {
                translate ([x,y,0]) {
                    cylinder(r=corner_radius,h=dims[2],center=true);
                }
            }
        }
        }
        //if (false) {
        // draw the inner cube
        //cube([dims[0]-2*corner_radius,dims[1]-2*corner_radius,dims[2]],center=true);
        // fill in the edges
        //for (x=corners_x) {
        //    translate([x,0,0]) {
        //        cube([2*corner_radius,dims[1]-2*corner_radius,dims[2]],center=true);
        //    }
        //}
        //for (y=corners_y) {
        //    translate([0,y,0]) {
        //        cube([dims[0]-2*corner_radius,2*corner_radius,dims[2]],center=true);
        //    }
        //}
        //}
        
    }
}

module rounded_shaft(
    center, // x,y,z coordinates of center
    dims, // width (x dimension), length (y dimension), height (z dimension) (INSIDE of shaft)
    corner_radius, // the radius of the corners of the INSIDE of the shaft
    wall_thickness, // the thickness of the walls
) {
difference(){
rounded_square(center,[dims.x+2*wall_thickness,dims.y+2*wall_thickness,dims.z],wall_thickness+corner_radius);
rounded_square(center,[dims.x,dims.y,dims.z+1e-3],corner_radius);
}
}

module rounded_shaft_outside(
    center, // x,y,z coordinates of center
    dims, // width (x dimension), length (y dimension), height (z dimension) (OUTSIDE of shaft)
    corner_radius, // the radius of the corners of the OUTSIDE of the shaft
    wall_thickness, // the thickness of the walls
) {
difference(){
rounded_square(center,[dims.x,dims.y,dims.z],corner_radius);
rounded_square(center,[dims.x-(2*wall_thickness),dims.y-(2*wall_thickness),dims.z+1e-3],
((corner_radius-wall_thickness) < 1e-3 ? 1e-3 : (corner_radius-wall_thickness)));
}
}

// This is like a shaft but closed at one end and filled with a cross. All walls
// have the same thickness to prevent warping
module rounded_key(
    center, // x,y,z coordinates of center
    dims, // width (x dimension), length (y dimension), height (z dimension) (OUTSIDE of cube)
    corner_radius, // the radius of the corners of the INSIDE of the shaft
    wall_thickness, // the thickness of the walls
) {
if ((dims.x > 2*wall_thickness)&&(dims.y > 2*wall_thickness)) {
union () {
rounded_shaft_outside(center,dims,corner_radius,wall_thickness);
// "filler"
translate(center) {
cube([dims.x,wall_thickness,dims.z],center=true);
cube([wall_thickness,dims.y,dims.z],center=true);
// lid
rounded_square([0,0,dims.z*0.5-wall_thickness*0.5],
    [dims.x,dims.y,wall_thickness],
    corner_radius);
}
}
} else {
rounded_square(center,dims,corner_radius);
}
}
