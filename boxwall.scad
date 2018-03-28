// Coordinates
box_width=70; // x-dimension
box_length=100; // y-dimension
box_wall=2.5;
play=5;
encoder_clearance=7;
pcb_thickness=1.575;
dc_jack_height=11;
midi_jack_height=19.6;
box_height=encoder_clearance+pcb_thickness+max(dc_jack_height,midi_jack_height)+2*box_wall+play; 
echo(box_height);
corner_r=1.25;

midi_jack_spacing=2.5;
midi_jack_width=20.9;
midi_jack_hole_center_relative=9.7;
midi_jack_center_z=box_height-box_wall-encoder_clearance-pcb_thickness-midi_jack_hole_center_relative;
midi_jack_hole_radius=7.5;
midi_jack_center_x=[
    box_wall+play+midi_jack_width*0.5,
    box_wall+play+midi_jack_spacing+midi_jack_width+midi_jack_width*0.5,
];

dc_jack_spacing=2.5;
dc_jack_width=9;
dc_jack_center_x=midi_jack_center_x[len(midi_jack_center_x)-1]+midi_jack_width*0.5+dc_jack_spacing+dc_jack_width*0.5;
dc_jack_center_z=box_height-box_wall-encoder_clearance-pcb_thickness-dc_jack_height*0.5;

// Detail
$fn=50;


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
module box_top() {
    translate([0,0,box_height-box_wall+corner_r])
    cube([box_width,box_length,box_wall]);
}

module midi_jack_holes() {
    for (x=midi_jack_center_x) {
        translate([x,0,midi_jack_center_z])
        rotate([90,0,0])
        cylinder(r=midi_jack_hole_radius,h=2*box_wall,center=true);
    }
}
    
module dc_jack_hole() {
    translate([dc_jack_center_x,0,dc_jack_center_z])
    cube(size=[dc_jack_width,2*box_wall,dc_jack_height],center=true);
}

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
difference () {
    box_walls();
    midi_jack_holes();
    dc_jack_hole();
}
box_top();
