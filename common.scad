function assertion_failed()=(assertion_failed());

module domeassert(x,msg)
{ 
if (!x) {
    echo("this shit failed:", msg);
    echo("",assertion_failed());
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
        for (x=corners_x) {
            for(y=corners_y) {
                translate ([x,y,0]) {
                    cylinder(r=corner_radius,h=dims[2],center=true);
                }
            }
        }
        // draw the inner cube
        cube([dims[0]-2*corner_radius,dims[1]-2*corner_radius,dims[2]],center=true);
        // fill in the edges
        for (x=corners_x) {
            translate([x,0,0]) {
                cube([2*corner_radius,dims[1]-2*corner_radius,dims[2]],center=true);
            }
        }
        for (y=corners_y) {
            translate([0,y,0]) {
                cube([dims[0]-2*corner_radius,2*corner_radius,dims[2]],center=true);
            }
        }
        
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

function zeroz(p)=[p[0],p[1],0];
function wrap(i,mi,ma)=(i<mi?wrap(i+(ma-mi),mi,ma):i>=ma?wrap(i-(ma-mi),mi,ma):i);
function index_slice(a,start,end)=[for(i=[start:(end-1)])a[wrap(i,0,len(a))]];

// The distance between parts that are supposed to fit snuggly
tight_gap=0.5;

// The minimum amount of material (e.g., silicone) between the part and the edge of the mold
min_mold_thickness=13; // roughly .5 inch
