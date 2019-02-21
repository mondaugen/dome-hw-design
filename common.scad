// All dimensions in millimeters

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

// The diameter of the bolts used to attach parts of the mold together
mold_assemble_bolt_diameter=3;

// The diameter of the shafts housing the assembly bolts
mold_assemble_bolt_housing_diameter=mold_assemble_bolt_diameter+0.5;

// The thickness of the mold's walls
mold_wall_thickness=mold_assemble_bolt_housing_diameter+2.5;

// The height of the upper opening of the inner mold holder's air holes. These
// are slightly below the xy plane of the top of the inner holder because when
// molding, the mold will be upside down and we want to guide the bubbles to
// float out. The top of the inner mold slopes towards these openings to make a
// guide.
inner_mold_air_hole_z=-3;

// How far down the top of the cylinder is that maintains a curved bottom for
// the inside of the inner holder
inner_mold_inside_med_cyl_z=0.5*inner_mold_air_hole_z;

// The diameter of the air holes in the inner mold
inner_mold_air_hole_inner_diameter=5;

// The diameter of the shaft surrounding the air hole in the inner mold
inner_mold_air_hole_outer_diameter=6;


function ratio_w_gap(
length,
gap)=(length+2*gap)/length;

module scale_to_get_gap(
x_length,
y_length,
z_length,
x_gap,
y_gap,
z_gap){
echo("",ratio_w_gap(x_length,x_gap));
scale([
ratio_w_gap(x_length,x_gap),
ratio_w_gap(y_length,y_gap),
ratio_w_gap(z_length,z_gap)
]) children();
}

function vrange(x,start,stop)=
start==stop?x[start]:concat(x[start],vrange(x,start+1,stop));
