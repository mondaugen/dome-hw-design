use <rounded_polygon.scad>
use <../Round-Anything/polyround.scad>
use <smooth_polyhedron.scad>

// Add radius to all points
function points_w_radius(p,radius)=[for(i=[0:len(p)-1])[p[i].x,p[i].y,radius]];
// Like polyRound but constant radius
function polyRoundC(points,radius,fn=5,mode=0)=
 polyRound(points_w_radius(points,radius),fn,mode);
// Mirror xy points around x axis
function mirror_xy_x(p)=[for(i=[0:len(p)-1])[p[i].x*-1,p[i].y]];
// Mirror xy points around y axis
function mirror_xy_y(p)=[for(i=[0:len(p)-1])[p[i].x,p[i].y*-1]];
function mirror_xy_xy(p)=mirror_xy_x(mirror_xy_y(p));
// Translate xy points in a list by q
function translate_xy(p,q)=[for(i=[0:len(p)-1])[p[i].x+q.x,p[i].y+q.y]];

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
echo("box height",box_height);
corner_r=1;
inner_box_wall_z=box_height-box_wall;

component_wall_margin=2.5; // minimum distance from inner wall to component
jack_controls_margin=2; // minimum distance from jack components to lower components

right_box_outer=box_width+corner_r;
right_box_inner=right_box_outer-box_wall;
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
pcb_top_z=inner_box_wall_z-pcb_top_inner_wall_dist;
pcb_bottom_z=pcb_top_z-pcb_thickness;
echo("pcb_bottom_z",pcb_bottom_z);

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
led_block_x=(box_wall+component_wall_margin);
led_block_y=top_box_outer-(box_wall+jack_y_occupation
        +jack_controls_margin+led_block_height);
led_block_z=pcb_top_z;//box_height-led_hole_depth-led_hole_cover;


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

button_width=10;
button_height=10;
button_margin=2.5;
brc_buttons_anchor_x=right_box_outer-(box_wall+component_wall_margin+button_width*0.5);
brc_buttons_x=[brc_buttons_anchor_x,
    brc_buttons_anchor_x - (button_margin + button_width)];
brc_buttons_y=box_wall+component_wall_margin+button_height*0.5;

blc_buttons_anchor_x=box_wall+component_wall_margin+button_width*0.5;
blc_buttons_anchor_y=box_wall+component_wall_margin+button_height*0.5;
blc_bottom_buttons_x=[blc_buttons_anchor_x,blc_buttons_anchor_x+button_width+button_margin];
blc_top_buttons_x=[blc_bottom_buttons_x[0]+button_width*(2/3),blc_bottom_buttons_x[1]+button_width*(2/3)];
blc_buttons_y=[blc_buttons_anchor_x,blc_buttons_anchor_x+button_height+button_margin];

pcb_screw_len=8;
pcb_screw_pilot_hole_radius=1;
pcb_screw_hole_shell_width=3;
pcb_screw_hole_z=pcb_top_z-pcb_thickness;
right_pcb_screw_x=right_box_outer-box_wall-(pcb_screw_hole_shell_width+pcb_screw_pilot_hole_radius);
pcb_screw_coords=[
    [box_wall+pcb_screw_hole_shell_width+pcb_screw_pilot_hole_radius-corner_r,
        led_block_y-(pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width)],
    [led_block_x+led_block_width+pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width,
        led_block_y+led_block_height-(pcb_screw_hole_shell_width+pcb_screw_pilot_hole_radius)],
    [box_wall-corner_r+(pcb_screw_hole_shell_width+pcb_screw_pilot_hole_radius),
        box_wall-corner_r+(pcb_screw_hole_shell_width+pcb_screw_pilot_hole_radius)],
    [right_pcb_screw_x,brc_buttons_y+button_height*0.5+pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width]
];

encoder_x=right_pcb_screw_x-(pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width+encoder_width*0.5);

// tabs to catch on walls
tab_corner_r=.5;
tab_top_z=20;
tab_height=20-tab_corner_r;
tab_protrusion=2;
tab_width=20;
tab_points_y=[box_length*(1/4),box_length*(3/4)];

// the bottom (closing the shape), called the "lid"
// gap between box and lid
lid_gap=0.2;
// corner closest to origin
lid_corner=2*corner_r+lid_gap;
// length in y-direction
lid_length=box_length-2*(2*corner_r+lid_gap);
// length in x-direction
lid_width=box_width-2*(2*corner_r+lid_gap);
// height of bottom part of lid (excluding tabs)
lid_height=tab_top_z-tab_height;
lid_round=corner_r;
lid_center=[box_width*0.5,box_length*0.5];
lid_top_width=lid_width-2*(box_wall);
lid_top_length=lid_length-2*(box_wall);
lid_points=translate_xy([
                    [0,0],
                    [0+lid_width,0],
                    [0+lid_width,0+lid_length],
                    [0,0+lid_length]],-1*[lid_width*0.5,lid_length*0.5]);
lid_shell_length=lid_length+2*lid_gap;
lid_shell_width=lid_width+2*lid_gap;

// Detail
$fn=20;

module box_walls() {
    for (p=[[box_wall,box_length],[box_width,box_wall]]) {
        rounded_cube(p.x,p.y,box_height,corner_r);
    }
    translate([box_width,box_length])
    mirror([1,1,0])
    for (p=[[box_wall,box_length],[box_width,box_wall]]) {
        rounded_cube(p.x,p.y,box_height,corner_r);
    }
}
module box_top() {
    translate([0,0,inner_box_wall_z])
    rounded_cube(box_width,box_length,box_wall,corner_r);
}

module midi_jack_holes() {
    for (x=midi_jack_center_x) {
        translate([x,box_length-box_wall*0.5,midi_jack_center_z])
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
    translate([led_block_x,led_block_y,led_block_z]) 
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
    
module button_holes () {
    // bottom right hand corner holes
    for (x=brc_buttons_x) {
        rounded_square([x,brc_buttons_y,box_height],[button_width,button_height,10],corner_r);
    }
    for (x=blc_bottom_buttons_x) {
        rounded_square([x,blc_buttons_y[1],box_height],[button_width,button_height,10],corner_r);
    }
    for (x=blc_top_buttons_x) {
        rounded_square([x,blc_buttons_y[0],box_height],[button_width,button_height,10],corner_r);
    }
}

module pcb_screw_holes () {
    translate([0,0,pcb_screw_hole_z])
    for (point=pcb_screw_coords) {
        translate(point)
               cylinder(r=pcb_screw_pilot_hole_radius,h=pcb_screw_len,center=false); 
    }
}

module pcb_screw_shells () {
    // Need to add a tiny bit extra so that the shapes don't just "kiss"
    translate([0,0,pcb_screw_hole_z+pcb_thickness])
    for (point=pcb_screw_coords) {
        translate(point)
               cylinder(r=pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width+0.001,
                    h=inner_box_wall_z-(pcb_screw_hole_z+pcb_thickness)+0.001,center=false); 
    }
}

//translate([box_wall-corner_r,0,-5]) cube([10,10,10]);
module wall_tabs() {
    leftout=box_wall-corner_r;
    rightout=right_box_inner;
    for (point=tab_points_y) {
        translate([leftout,point+tab_width*0.5,0]) rotate([90,0,0])
            translate([0,tab_top_z-tab_height,0])
            linear_extrude(height=tab_width) {
                polygon(polyRoundC([
                            // dummy corners inside the wall
                            //top
                            [0,tab_height+tab_corner_r],
                            [-tab_corner_r,tab_height+tab_corner_r],
                            // bottom
                            [-tab_corner_r,-tab_corner_r],
                            [0,-tab_corner_r],
                            // corners of shape
                            [0,0],
                            [tab_protrusion,tab_height],
                            [0,tab_height]
                            ],tab_corner_r,$fn,0));
            }
        translate([rightout,point+tab_width*0.5,0]) rotate([90,0,0])
            translate([0,tab_top_z-tab_height,0])
            linear_extrude(height=tab_width) {
                polygon(polyRoundC(
                            mirror_xy_x([
                                // dummy corners inside the wall
                                //top
                                [0,tab_height+tab_corner_r],
                                [-tab_corner_r,tab_height+tab_corner_r],
                                // bottom
                                [-tab_corner_r,-tab_corner_r],
                                [0,-tab_corner_r],
                                // corners of shape
                                [0,0],
                                [tab_protrusion,tab_height],
                                [0,tab_height]
                                ]),tab_corner_r,$fn,0));
            }
    }
}

module lid_solid () {
    translate(lid_center)
    linear_extrude(height=box_wall,scale=[lid_top_width/lid_width,lid_top_length/lid_length],center=false) {
        polygon(polyRoundC(lid_points,
                    lid_round,
                    $fn));
    }
}

module lid_void () {
    translate(lid_center)
    linear_extrude(height=box_wall,scale=[lid_top_width/lid_width,lid_top_length/lid_length],center=false) {
        scale([lid_shell_width/lid_width,
                lid_shell_length/lid_length]) 
            polygon(polyRoundC(lid_points,
                        lid_round,
                        $fn));
    }
}

// The box
difference () {
union () {
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
            pcb_screw_shells();
            wall_tabs();
        }
        union () {
            led_holes();
            encoder_holes();
            button_holes();
            pcb_screw_holes();
        }
    }
}
union () {
    translate([0,0,-0.001])
        lid_void ();
}
}

// The lid
union () {
    lid_solid();
}

module sanity_check_width () {
    translate([0,0,-10])
    cube([right_box_outer,10,100]);
}

module sanity_check_height () {
    translate([0,0,-10])
    cube([10,top_box_outer,100]);
}

module sanity_check_z () {
    translate([-5,-5,0])
    cube([10,10,inner_box_wall_z]);
}

//sanity_check_width();
//sanity_check_height();
//sanity_check_z();
