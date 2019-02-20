include <common.scad>
use <boxwall.scad>

// the inner holder of the mold is built around the bottom of the case
// the origin of the case is 0 0 0, so the top right and highest corner's
// coordinate is box_dimensions()

// to properly hold the bottom of the case in the mold, we make a pocket by
// making the hull of spheres placed where the corner rounding places spheres,
// but whose radii are slightly larger so that there is a little bit of
// tolerance to fit the 2 pieces together
case_width=box_dimensions()[0];
case_length=box_dimensions()[1];
case_height=box_dimensions()[2];
case_bottom_holder_corner_sphere_centers=[
[corner_radius(),corner_radius(),corner_radius()],
[case_width-corner_radius(),corner_radius(),corner_radius()],
[case_width-corner_radius(),case_height-corner_radius(),corner_radius()],
[corner_radius(),case_height-corner_radius(),corner_radius()]
];

module case_bottom_holder_pocket () {
    hull() {
        for (p=case_bottom_holder_corner_sphere_centers) { translate(p) sphere(r=corner_radius()+tight_gap); }
    }
}
function case_bottom_holder_pocket_dims()=[for(p=box_dimensions())p+2*tight_gap];

// The distance from the bottom holder pocket
air_hole_offset=min_mold_thickness*0.5;
// The height above the bottom holder pocket of the bottom opening of the air hole
// this should be positive because the bubbles should travel upward

air_hole_z=1;
air_hole_coords=[
//[-air_hole_offset,-air_hole_offset,1],
//[case_bottom_holder_pocket_dims()[0]+air_hole_offset,-air_hole_offset,1],
//[
//    case_bottom_holder_pocket_dims()[0]+air_hole_offset,
//    case_bottom_holder_pocket_dims()[1]+air_hole_offset,1],
[0,0,1],
[5,0,1],
[5,5,1],
[0,5,1]
];
air_hole_height=0.5;
air_hole_void_height=1.5;
air_hole_outer_radius=0.5;
air_hole_void_radius=0.25;


screw_hole_coords=[
[1,1,0],
[4,1,0],
[4,4,0],
[1,4,0]
];
screw_hole_height=1;
screw_hole_outer_radius=0.5;

shaft_attach_hole_coords=[
[-2,-2,0],
[7,-2,0],
[7,7,0],
[-2,7,0]
];
shaft_attach_hole_height=air_hole_void_height;
shaft_attach_hole_outer_radius=1;
shaft_attach_hole_inner_radius=0.25;

med_cyl_z=0.25;
med_cyl_coords=[
[2.5,0,med_cyl_z],
[5,2.5,med_cyl_z],
[2.5,5,med_cyl_z],
[0,2.5,med_cyl_z]
];
med_cyl_height=shaft_attach_hole_height-med_cyl_z;
med_cyl_radius=0.001;

outer_med_cyl_radius=0.001;
outer_med_cyl_offset=shaft_attach_hole_outer_radius-outer_med_cyl_radius;
outer_med_cyl_coords=[
[2.5,-2-outer_med_cyl_offset,0.125],
[7+outer_med_cyl_offset,2.5,0.125],
[2.5,7+outer_med_cyl_offset,0.125],
[-2-outer_med_cyl_offset,2.5,0.125]
];
outer_med_cyl_height=shaft_attach_hole_height-0.125;

module inner_curved_bottom () {
difference () {
hull () {
for (p=air_hole_coords) { translate(p) cylinder(r=air_hole_outer_radius,h=air_hole_height); }
for (p=med_cyl_coords) { translate(p) cylinder(r=med_cyl_radius,h=med_cyl_height); }
for (p=screw_hole_coords) { translate(p) cylinder(r=screw_hole_outer_radius,h=screw_hole_height); }
}
union () {
for (p=air_hole_coords) {
translate(zeroz(p)) cylinder(r=air_hole_void_radius,h=air_hole_void_height); 

}
}
}
}

module outer_curved_bottom () {
    for(i=[0:3]){
        difference () {
            union () {
            hull () {
                translate(shaft_attach_hole_coords[i]) 
                        cylinder(r=shaft_attach_hole_outer_radius,h=shaft_attach_hole_height);
                translate(med_cyl_coords[i])
                    cylinder(r=med_cyl_radius,h=med_cyl_height);
                translate(outer_med_cyl_coords[i])
                    cylinder(r=outer_med_cyl_radius,h=outer_med_cyl_height);
                translate(air_hole_coords[i]) cylinder(r=air_hole_outer_radius,h=air_hole_height);
            }
            hull () {
                translate(
                    shaft_attach_hole_coords[wrap(i+1,0,len(shaft_attach_hole_coords))]) 
                    cylinder(r=shaft_attach_hole_outer_radius,h=shaft_attach_hole_height);
                translate(med_cyl_coords[i])
                    cylinder(r=med_cyl_radius,h=med_cyl_height);
                translate(outer_med_cyl_coords[i])
                    cylinder(r=outer_med_cyl_radius,h=outer_med_cyl_height);
                translate(air_hole_coords[wrap(i+1,0,len(air_hole_coords))])
                    cylinder(r=air_hole_outer_radius,h=air_hole_height);
            }
            }
            union () {
                translate(shaft_attach_hole_coords[i])
                    cylinder(r=shaft_attach_hole_inner_radius,h=shaft_attach_hole_height);
                translate(zeroz(air_hole_coords[i]))
                    cylinder(r=air_hole_void_radius,h=air_hole_void_height);
                translate(shaft_attach_hole_coords[wrap(i+1,0,len(shaft_attach_hole_coords))]) 
                    cylinder(r=shaft_attach_hole_inner_radius,h=shaft_attach_hole_height);
                translate(zeroz(air_hole_coords[wrap(i+1,0,len(air_hole_coords))]))
                    cylinder(r=air_hole_void_radius,h=air_hole_void_height);
            }
        }
    }
}

module mold_inner_holder_bottom() {
    inner_curved_bottom();
    outer_curved_bottom();
}
