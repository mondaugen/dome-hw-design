box_width=70; // x-dimension
box_length=100; // y-dimension
box_wall=2.5;
play=5;
box_height=(7+2+11+2*box_wall+play); // z-dimension, encoder height 7mm + pcb 2mm + dc jack 11mm + 2 x box_wall
echo(box_height);
corner_r=0.2;
$fn=20;
module box_xy_corner() {
    rotate([-90,0,0])
        cylinder(r=corner_r,h=box_length);
    rotate([0,90,0])
        cylinder(r=corner_r,h=box_width);
    sphere(corner_r);
    translate([box_width,0,0])
        sphere(corner_r);
    translate([0,box_length,0])
        sphere(corner_r);
}
module box_corner_posts() {
    for (x=[0,box_width]) {
        for (y=[0,box_length]) {
            translate([x,y,0])
                cylinder(r=corner_r,h=box_height);
        }
    }
}
module box_walls() {
    for (x=[0,box_width-box_wall+2*corner_r]) {
        translate([x-corner_r,0,0])
            cube([box_wall,box_length,box_height]);
    }
    for (y=[0,box_length-box_wall+2*corner_r]) {
        translate([0,y-corner_r,0])
            cube([box_width,box_wall,box_height]);
    }
}

//function cross_prod_3d(u,v) =
//    [u[1]*v[2]-u[2]*v[1],
//       u[2]*v[0]-u[0]*v[2],
//       u[0]*v[1]-u[1]*v[0]];

//function magnitude(u) = 0;
    

box_xy_corner();
rotate([0,0,180])
    translate([-box_width,-box_length,0])
        box_xy_corner();
translate([0,0,box_height]) {
box_xy_corner();
rotate([0,0,180])
    translate([-box_width,-box_length,0])
        box_xy_corner();
}
box_corner_posts();
box_walls();
