// Coordinates
box_width=70; // x-dimension
box_length=70; // y-dimension
box_wall=2.5;
play=5;
encoder_clearance=7;
pcb_thickness=1.575;
dc_jack_height=11;
midi_jack_height=19.6;
box_height=encoder_clearance+pcb_thickness+max(dc_jack_height,midi_jack_height)+2*box_wall+play; 
echo(box_height);
corner_r=0.25;

component_wall_margin=2.5; // minimum distance from inner wall to component
jack_controls_margin=2; // minimum distance from jack components to lower components

right_box_outer=box_width+corner_r;
top_box_outer=box_length+corner_r;

midi_jack_spacing=2.5;
midi_jack_width=20.9;
midi_jack_depth=15;
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
dc_jack_depth=14.2;
dc_jack_protrusion=7; // how far DC jack hangs off of PCB
dc_jack_intrusion=dc_jack_depth-dc_jack_protrusion; // how far dc jack goes into PCB
jack_y_occupation=max([dc_jack_intrusion,midi_jack_depth]);

pcb_top_inner_wall_dist=encoder_clearance; // distance between top of pcb and inner top wall

led_hole_cover=0.5;
led_hole_cover_initial=1.5;
// the distance between the top of the PCB and the bottom of the
// led hole covering
led_hole_depth=pcb_top_inner_wall_dist+box_wall-led_hole_cover;
led_hole_depth_initial=pcb_top_inner_wall_dist+box_wall-led_hole_cover_initial;
led_hole_size=1.5;
led_hole_margin=1.5;
n_leds_x=10;
n_leds_y=4;
// Just a bit of space to assure the parts are correctly 
//differenced (no walls of 0 width)
led_hole_play=0.1; 
led_block_height=led_hole_margin+(led_hole_size+led_hole_margin)*n_leds_y;
led_block_width=led_hole_margin+(led_hole_size+led_hole_margin)*n_leds_x;

encoder_margin=2.5;
encoder_length=13.75;
encoder_top_to_center=7.25;
encoder_width=12;
encoder_hole_radius=6.35*0.5;
encoder_y=[
    box_length-(box_wall+jack_y_occupation+jack_controls_margin+encoder_top_to_center),
    box_length-(box_wall+jack_y_occupation+jack_controls_margin+encoder_top_to_center
        +encoder_length+encoder_margin),
];
encoder_x=right_box_outer-(box_wall+component_wall_margin+encoder_width*0.5);


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
        translate([x,top_box_outer-corner_r,midi_jack_center_z])
        rotate([90,0,0])
        cylinder(r=midi_jack_hole_radius,h=2*box_wall,center=true);
    }
}
    
module dc_jack_hole() {
    translate([dc_jack_center_x,top_box_outer-corner_r,dc_jack_center_z])
    cube(size=[dc_jack_width,2*box_wall,dc_jack_height],center=true);
}

module square_block_grid(
    block_size, // width and height of blocks
    margin_size, // space between blocks
    block_depth, // depth of the blocks
    num_x, // number of blocks in the x dimension
    num_y, // number of blocks in the y dimension
) {
    translate([margin_size,margin_size,0])
    for (i = [0:num_x-1]) {
        for (j = [0:num_y-1]) {
            translate([i*(block_size+margin_size),j*(block_size+margin_size),0])
                cube([block_size,block_size,block_depth]);
        }
    }
}

// Like square_block_grid but moves from depth1 to depth2 over the x dimension
// (for seeing how different depths work for different light intensities
module square_block_grid_graded(
    block_size, // width and height of blocks
    margin_size, // space between blocks
    block_depth1, // depth of the blocks
    block_depth2, // depth of the blocks
    num_x, // number of blocks in the x dimension
    num_y, // number of blocks in the y dimension
) {
    translate([margin_size,margin_size,0])
    for (i = [0:num_x-1]) {
        for (j = [0:num_y-1]) {
            translate([i*(block_size+margin_size),j*(block_size+margin_size),0])
                cube([block_size,block_size,
                block_depth1+i*(num_x > 1 ? (block_depth2-block_depth1)/(num_x-1) : 0)]);
        }
    }
}

module led_block() {
    translate([(box_wall+component_wall_margin),
        top_box_outer-(box_wall+jack_y_occupation
            +jack_controls_margin+led_block_height),
        box_height-led_hole_depth-led_hole_cover]) 
    cube([led_hole_margin+n_leds_x*(led_hole_size+led_hole_margin),
          led_hole_margin+n_leds_y*(led_hole_size+led_hole_margin),
          led_hole_depth]);
}
            
module led_holes() { 
    translate([(box_wall+component_wall_margin),
        top_box_outer-(box_wall+jack_y_occupation
            +jack_controls_margin+led_block_height),
        box_height-led_hole_depth-led_hole_cover-led_hole_play]) 
    // Graded for now to see what depth is best
    square_block_grid_graded(led_hole_size,led_hole_margin,
        led_hole_depth_initial+led_hole_play,
        led_hole_depth+led_hole_play,n_leds_x,n_leds_y);
    //square_block_grid(led_hole_size,led_hole_margin,
    //    led_hole_depth+led_hole_play,n_leds_x,n_leds_y);
}

module encoder_holes () {
    for (y=encoder_y) {
        translate([encoder_x,y,box_height-box_wall*0.5])
            cylinder(r=encoder_hole_radius,h=2*box_wall,center=true);
    }
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
difference () {

    union () {
        led_block();
        box_top();
    }
    union () {
        led_holes();
        encoder_holes();
    }
}

module sanity_check_width () {
    translate([0,0,-10])
    cube([right_box_outer,10,100]);
}

module sanity_check_height () {
    translate([0,0,-10])
    cube([10,top_box_outer,100]);
}
//sanity_check_width();
//sanity_check_height();
