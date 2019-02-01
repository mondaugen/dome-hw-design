use <common.scad>

$fn=20;

air_hole_coords=[
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
                translate(shaft_attach_hole_coords[wrap(i+1,0,len(shaft_attach_hole_coords))]) 
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

inner_curved_bottom();
outer_curved_bottom();
