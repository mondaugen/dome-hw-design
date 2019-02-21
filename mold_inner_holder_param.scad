include <common.scad>
use <boxwall.scad>

// This is a mold for an object like the top of a case where you want to mold
// the outside first, so the inner holder blocks the bottom opening of the case to
// prevent silicone from entering (the other holes in the case are temporarily
// plugged somehow).
// Then to mold the inside, the inner holder is removed, the holes are
// unplugged, and the outer holder is attached to the mold. Silicone is now
// poured to make the other half.

// the inner holder of the mold is built around the bottom of an object
// the origin of the object is 0 0 0, so the top right and highest corner's
// coordinate is equal to the object's dimensions

// to properly hold the bottom of the case in the mold, we make a pocket by
// determining a hull slightly larger than the object, translate this hull and
// subtract it from our mold part 

// the part's hull is specified using x_length,y_length,z_length. This means the
// origin of the part is 0,0,0 (if it isn't it needs to be translated so it is)

// "Up" in this drawing is based on the part's top. So if you are below the
// part, positive z moves towards the top of the part.

// based on the xy dimensions of the part, determine the xy positions of the
// holes housing the bolts that hold the inner shaft onto the inner holder
function inner_shaft_attach_hole_coords(
x_length,
y_length)=
let(shaft_offset=min_mold_thickness-mold_wall_thickness*0.5)
[
[-shaft_offset,-shaft_offset],
[x_length+shaft_offset,-shaft_offset],
[x_length+shaft_offset,y_length+shaft_offset],
[-shaft_offset,y_length+shaft_offset]
];


// based on the xy dimensions of the part, determine the xy positions of the
// holes housing the bolts that hold the outer shaft onto the outer holder and
// mold top
function outer_shaft_attach_hole_coords(
x_length,
y_length)=
let(shaft_offset=min_mold_thickness+mold_wall_thickness*0.5)
[
[-shaft_offset,-shaft_offset],
[x_length+shaft_offset,-shaft_offset],
[x_length+shaft_offset,y_length+shaft_offset],
[-shaft_offset,y_length+shaft_offset]
];


// The air holes that allow bubbles in the silicone to escape. These are located
// halfway between the edge of the object and the inner edge of the outer shaft
// in the xy plane.
// z offset is how much we sink the part into the inner holder in the z
// direction to make a tight seal
function inner_holder_air_hole_coords(
x_length,
y_length,
z_offset)=
let(
// The distance from the bottom holder pocket
air_hole_offset=min_mold_thickness*0.5,
air_hole_z=z_offset+inner_mold_air_hole_z)
[
[-air_hole_offset,-air_hole_offset,air_hole_z],
[x_length+air_hole_offset,-air_hole_offset,air_hole_z],
[x_length+air_hole_offset,y_length+air_hole_offset,air_hole_z],
[-air_hole_offset,y_length+air_hole_offset,air_hole_z]
];

// SUPERCEDED by inner_holder_air_hole_coords
//air_hole_coords=[
////[-air_hole_offset,-air_hole_offset,1],
////[case_bottom_holder_pocket_dims()[0]+air_hole_offset,-air_hole_offset,1],
////[
////    case_bottom_holder_pocket_dims()[0]+air_hole_offset,
////    case_bottom_holder_pocket_dims()[1]+air_hole_offset,1],
//[0,0,1],
//[5,0,1],
//[5,5,1],
//[0,5,1]
//];
//air_hole_height=0.5;
//air_hole_void_height=1.5;
//air_hole_outer_radius=0.5;
//air_hole_void_radius=0.25;


// SUPERCEDED These will be provided when the module drawing the inner holder is
// called
//screw_hole_coords=[
//[1,1,0],
//[4,1,0],
//[4,4,0],
//[1,4,0]
//];
//screw_hole_height=1;
//screw_hole_outer_radius=0.5;

// SUPERCEDED by inner_shaft_attach_hole_coords
//// These are the coordinates of the holes that attach the shaft that allow the
//// mold part to descend into the outer mold
//shaft_attach_hole_coords=[
//[-2,-2,0],
//[7,-2,0],
//[7,7,0],
//[-2,7,0]
//];
//shaft_attach_hole_height=air_hole_void_height;
//shaft_attach_hole_outer_radius=1;
//shaft_attach_hole_inner_radius=0.25;

// Make a socket so that the part fits snuggly with the inner holder
// - take the part and the dimensions of its rectangular prism hull (the part is
// specified as a child element)
// - move the part down in z so as to "sink it" into the inner holder (note that
// we still use the convention that positive z is up so z should be negative in
// order to move down)
// - expand the part slightly to make a tolerance gap
module inner_holder_part_socket(
x_length,
y_length,
z_length,
tolerance_gap,
sink_z_dist)
{
    translate([0,0,sink_z_dist]) {
    scale_to_get_gap(
    x_length,
    y_length,
    z_length,
    tolerance_gap,
    tolerance_gap,
    tolerance_gap) { children(); } }
}

// The part socket as a solid so we can combine it with other shapes to make the inside bottom
module inner_holder_part_socket_solid(
x_length,
y_length,
z_length,
tolerance_gap,
sink_z_dist)
{
    intersection () {
        translate([0,0,sink_z_dist]) cube([x_length,y_length,-1*sink_z_dist]);
        inner_holder_part_socket(x_length,
        y_length,
        z_length,
        tolerance_gap,
        sink_z_dist);
    }
}

// the maxmimum thickness of the bottom of the inner mold
function inner_mold_bottom_max_thickness(sink_z_dist)=
-1*sink_z_dist + -1*inner_mold_air_hole_z+mold_wall_thickness;

// These are cylinders used when generating the inside curved bottom so that
// there are no flat regions. Returns tuples of [x,y,z,h]
function inner_holder_inside_bottom_med_cyl_coords(
x_length,
y_length,
sink_z_dist)=
let(
// the z coordinate of the top of the cylinder
med_cyl_z=0.5*inner_mold_air_hole_z+sink_z_dist,
// the z coordinate of the bottom of the cylinder,
med_cyl_z_bottom=-1*inner_mold_bottom_max_thickness(sink_z_dist),
// the height of the cylinder
med_cyl_h=med_cyl_z-med_cyl_z_bottom,
med_cyl_offset=min_mold_thickness*0.5
)
[
[-med_cyl_offset,y_length*0.5,med_cyl_z_bottom,med_cyl_h],
[x_length*0.5,-med_cyl_offset,med_cyl_z_bottom,med_cyl_h],
[x_length+med_cyl_offset,y_length*0.5,med_cyl_z_bottom,med_cyl_h],
[x_length*0.5,y_length+med_cyl_offset,med_cyl_z_bottom,med_cyl_h],
];

// the radius of these cylinders (basically infinitesimally small)
med_cyl_radius=1;//0.001;

function inner_mold_air_hole_height(sink_z_dist)=
inner_mold_bottom_max_thickness(sink_z_dist)+inner_mold_air_hole_z;

module inner_curved_bottom (
x_length,
y_length,
z_length,
sink_z_dist,
tolerance_gap) {
//difference () {
//hull () {
for (p=inner_holder_air_hole_coords(x_length,y_length,sink_z_dist)) {
    translate(p) cylinder(r=inner_mold_air_hole_outer_diameter*0.5,
    h=inner_mold_air_hole_height(sink_z_dist)); }
for (p=inner_holder_inside_bottom_med_cyl_coords(
    x_length,
    y_length,
    sink_z_dist)) { translate(vrange(p,0,2)) cylinder(r=med_cyl_radius,h=p[3]); }
inner_holder_part_socket_solid(
    x_length,
    y_length,
    z_length,
    tolerance_gap,
    sink_z_dist);
//}
//union () {
//for (p=inner_holder_air_hole_coords(x_length,y_length,sink_z_dist)) {
//    translate(zeroz(p))
//    translate([0,0,-1*inner_mold_bottom_max_thickness])
//    cylinder(r=inner_mold_air_hole_inner_diameter*0.5,
//        h=inner_mold_bottom_max_thickness); } 
//inner_holder_part_socket_solid(
//    x_length,
//    y_length,
//    z_length,
//    tolerance_gap,
//    sink_z_dist);
//
//}
//}
} 

//med_cyl_z=0.25;
//med_cyl_coords=[
//[2.5,0,med_cyl_z],
//[5,2.5,med_cyl_z],
//[2.5,5,med_cyl_z],
//[0,2.5,med_cyl_z]
//];
//med_cyl_height=shaft_attach_hole_height-med_cyl_z;
//med_cyl_radius=0.001;
//
//outer_med_cyl_radius=0.001;
//outer_med_cyl_offset=shaft_attach_hole_outer_radius-outer_med_cyl_radius;
//outer_med_cyl_coords=[
//[2.5,-2-outer_med_cyl_offset,0.125],
//[7+outer_med_cyl_offset,2.5,0.125],
//[2.5,7+outer_med_cyl_offset,0.125],
//[-2-outer_med_cyl_offset,2.5,0.125]
//];
//outer_med_cyl_height=shaft_attach_hole_height-0.125;
//
//module inner_curved_bottom () {
//difference () {
//hull () {
//for (p=air_hole_coords) { translate(p) cylinder(r=air_hole_outer_radius,h=air_hole_height); }
//for (p=med_cyl_coords) { translate(p) cylinder(r=med_cyl_radius,h=med_cyl_height); }
//for (p=screw_hole_coords) { translate(p) cylinder(r=screw_hole_outer_radius,h=screw_hole_height); }
//}
//union () {
//for (p=air_hole_coords) {
//translate(zeroz(p)) cylinder(r=air_hole_void_radius,h=air_hole_void_height); 
//
//} } } } 
//
//module outer_curved_bottom () {
//    for(i=[0:3]){
//        difference () {
//            union () {
//            hull () {
//                translate(shaft_attach_hole_coords[i]) 
//                        cylinder(r=shaft_attach_hole_outer_radius,h=shaft_attach_hole_height);
//                translate(med_cyl_coords[i])
//                    cylinder(r=med_cyl_radius,h=med_cyl_height);
//                translate(outer_med_cyl_coords[i])
//                    cylinder(r=outer_med_cyl_radius,h=outer_med_cyl_height);
//                translate(air_hole_coords[i])
//                    cylinder(r=air_hole_outer_radius,h=air_hole_height);
//            }
//            hull () {
//                translate(
//                    shaft_attach_hole_coords[wrap(i+1,0,len(shaft_attach_hole_coords))]) 
//                    cylinder(r=shaft_attach_hole_outer_radius,h=shaft_attach_hole_height);
//                translate(med_cyl_coords[i])
//                    cylinder(r=med_cyl_radius,h=med_cyl_height);
//                translate(outer_med_cyl_coords[i])
//                    cylinder(r=outer_med_cyl_radius,h=outer_med_cyl_height);
//                translate(air_hole_coords[wrap(i+1,0,len(air_hole_coords))])
//                    cylinder(r=air_hole_outer_radius,h=air_hole_height);
//            }
//            }
//            union () {
//                translate(shaft_attach_hole_coords[i])
//                    cylinder(r=shaft_attach_hole_inner_radius,h=shaft_attach_hole_height);
//                translate(zeroz(air_hole_coords[i]))
//                    cylinder(r=air_hole_void_radius,h=air_hole_void_height);
//                translate(shaft_attach_hole_coords[wrap(i+1,0,len(shaft_attach_hole_coords))]) 
//                    cylinder(r=shaft_attach_hole_inner_radius,h=shaft_attach_hole_height);
//                translate(zeroz(air_hole_coords[wrap(i+1,0,len(air_hole_coords))]))
//                    cylinder(r=air_hole_void_radius,h=air_hole_void_height);
//            }
//        }
//    }
//}
//
//module mold_inner_holder_bottom() {
//    inner_curved_bottom();
//    outer_curved_bottom();
//}
