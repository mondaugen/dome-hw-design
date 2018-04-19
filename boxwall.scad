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
function mirror_xyz_x(p)=[for(i=[0:len(p)-1])[p[i].x*-1,p[i].y,p[i].z]];
// Mirror xy points around y axis
function mirror_xy_y(p)=[for(i=[0:len(p)-1])[p[i].x,p[i].y*-1]];
function mirror_xy_xy(p)=mirror_xy_x(mirror_xy_y(p));
// Translate xy points in a list by q
function translate_xy(p,q)=[for(i=[0:len(p)-1])[p[i].x+q.x,p[i].y+q.y]];
function trap_prism_points(w,l,h,in)=
[for(z=[0,h],x=[-1,1],y=[-1,1]) [x*(w*0.5-(z==h?in:0)),y*(l*0.5-(z==h?in:0)),z] ];
trap_prism_vertices=[
[1,2,4 ], // 0
[3,0,5 ], // 1
[0,3,6 ], // 2
[2,1,7 ], // 3
[5,6,0 ], // 4
[7,4,1], // 5
[4,7,2], // 6
[6,5,3] // 7
];
top_trap_prism_vertices=[
[1,2,4 ], // 0
[3,0,5 ], // 1
[0,4,6 ], // 2
[5,1,7 ], // 3
[2,6,0 ], // 4
[7,3,1], // 5
[4,7,2], // 6
[6,5,3] // 7
];


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
pcb_width=box_width-2*(box_wall);
pcb_length=box_length-2*(box_wall);

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
dc_jack_protrusion=box_wall; // how far DC jack hangs off of PCB
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
    [right_pcb_screw_x,
        brc_buttons_y+button_height*0.5+pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width+2]
];

encoder_x=right_pcb_screw_x-(pcb_screw_pilot_hole_radius+pcb_screw_hole_shell_width+encoder_width*0.5);

// tabs to catch on walls
tab_corner_r=1;
tab_height=20-box_wall;
tab_top_z=tab_height+box_wall;
tab_protrusion=2;
tab_width=20;
tab_points_y=[box_length*0.5];
wall_tab_points=[
[0,-tab_width*0.5-tab_protrusion,tab_height],
[0,+tab_width*0.5+tab_protrusion,tab_height],
[tab_protrusion,+tab_width*0.5,tab_height],
[tab_protrusion,-tab_width*0.5,tab_height],
[0,-tab_width*0.5,0],
[0,+tab_width*0.5,0]
];
lid_tab_base_width=20;
lid_tab_top_width=10;
lid_tab_points=[
[0,-tab_width*0.5-tab_protrusion,-box_wall+1e-3],
[0,+tab_width*0.5+tab_protrusion,-box_wall+1e-3],
[lid_tab_base_width,-tab_width*0.5,-box_wall+1e-3],
[lid_tab_base_width,+tab_width*0.5,-box_wall+1e-3],
[tab_protrusion,-tab_width*0.5-tab_protrusion,tab_top_z],
[tab_protrusion,+tab_width*0.5+tab_protrusion,tab_top_z],
[lid_tab_top_width,-tab_width*0.5,tab_top_z],
[lid_tab_top_width,+tab_width*0.5,tab_top_z]
];
// points of holes in tabs
// relative to the tab void points
lid_tab_void_points=[
[0,-(tab_width*0.5+tab_protrusion-box_wall),-box_wall-1e-2],
[0,+tab_width*0.5+tab_protrusion-box_wall,-box_wall-1e-2],
[lid_tab_base_width-2*box_wall,-(tab_width*0.5-box_wall),-box_wall-1e-2],
[lid_tab_base_width-2*box_wall,+tab_width*0.5-box_wall,-box_wall-1e-2],
[tab_protrusion,-(tab_width*0.5+tab_protrusion-box_wall),tab_top_z-box_wall],
[tab_protrusion,+tab_width*0.5+tab_protrusion-box_wall,tab_top_z-box_wall],
[lid_tab_top_width-2*box_wall,-(tab_width*0.5-box_wall),tab_top_z-box_wall],
[lid_tab_top_width-2*box_wall,+tab_width*0.5-box_wall,tab_top_z-box_wall]
];
lid_tab_top_height=2; // height of hook-part on lid tab
// TODO: This doesn't work, it doesn't like the 6 points on the same z, why?
lid_tab_top_points=[
[0,-tab_width*0.5,tab_top_z], // 0
[0,+tab_width*0.5,tab_top_z], // 1
[tab_protrusion,-(tab_width*0.5+tab_protrusion),tab_top_z-1e-3], // 2 
[tab_protrusion,+(tab_width*0.5+tab_protrusion),tab_top_z-1e-3],// 3 
[tab_protrusion,-tab_width*0.5,tab_top_z+lid_tab_top_height], // 4
[tab_protrusion,+tab_width*0.5,tab_top_z+lid_tab_top_height], // 5
[lid_tab_top_width,-tab_width*0.5,tab_top_z], // 6 
[lid_tab_top_width,+tab_width*0.5,tab_top_z] // 7
];
lid_tab_top_round=[0.25,0.25,1e-4,1e-4,0.5,0.5,1e-4,1e-4];
lid_tab_vertices=
[
[1,4,3],
[0,2,5],
[1,3,5],
[0,2,4],
[0,3,5],
[1,2,4]
];
lid_tab_round=[
1e-3,//tab_corner_r,
1e-3,//tab_corner_r,
1e-3,//tab_corner_r,
1e-3,//tab_corner_r,
1e-3,
1e-3,
1e-3,
1e-3
];


// the bottom (closing the shape), called the "lid"
// gap between box and lid
lid_gap=0;
// corner closest to origin
lid_corner=corner_r;//;2*corner_r+lid_gap;
// length in y-direction
lid_length=box_length;
// length in x-direction
lid_width=box_width;
    // height of bottom part of lid (excluding tabs)
lid_height=tab_top_z-tab_height;
echo("lid_height",lid_height);
lid_round=corner_r;
lid_center=[box_width*0.5,box_length*0.5,-(box_wall+lid_gap)];
lid_inset=0;
lid_top_width=lid_width;
lid_top_length=lid_length;
lid_points=translate_xy([
                    [0,0],
                    [0+lid_width,0],
                    [0+lid_width,0+lid_length],
                    [0,0+lid_length]],-1*[lid_width*0.5,lid_length*0.5]);
lid_shell_length=lid_length+2*lid_gap;
lid_shell_width=lid_width+2*lid_gap;

// Detail
$fn=10;

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

module wall_tabs() {
for(y=tab_points_y){
for(x=[box_wall,box_width-box_wall]){
translate([x,y,tab_top_z-tab_height])
rounded_convex_polyhedron(
x==box_width-box_wall?mirror_xyz_x(wall_tab_points):wall_tab_points,
[
[1,4,3],
[0,2,5],
[1,3,5],
[0,2,4],
[0,3,5],
[1,2,4]
],
[1e-3,1e-3,tab_corner_r,tab_corner_r,1e-3,1e-3]);
}
}
}

        

module lid_solid () {
    // bottom part
    translate(lid_center)
        hull () {
            rounded_convex_set_vertices(trap_prism_points(lid_width,lid_length,lid_height,lid_inset),
                    trap_prism_vertices,[for(i=[1:len(trap_prism_vertices)])lid_round]);
        }
    // tabs part
    for (x=[box_wall,box_width-box_wall], y=tab_points_y) {
        translate([x,y,0])
            hull () {
                rounded_convex_set_vertices(
                        x==box_width-box_wall?mirror_xyz_x(lid_tab_points):lid_tab_points,
                        trap_prism_vertices,lid_tab_round);
            }
        translate([x,y,0])
        hull () {
            rounded_convex_set_vertices(
                    x==box_width-box_wall?mirror_xyz_x(lid_tab_top_points):lid_tab_top_points,
                    top_trap_prism_vertices,//[for(i=[1:len(top_trap_prism_vertices)])1e-4]);//
                    lid_tab_top_round);
        }

    } 
}

module lid_void () {
    translate(lid_center)
        hull () {
            rounded_convex_set_vertices(trap_prism_points(lid_width,lid_length,lid_height,lid_inset),
                    trap_prism_vertices,[for(i=[1:len(trap_prism_vertices)])1e-3]);
        }
}

module tab_void () {
    // tabs part
    for (x=[2*box_wall,box_width-2*box_wall], y=tab_points_y) {
        translate([x,y,0])
            hull () {
                rounded_convex_set_vertices(
                        x==box_width-2*box_wall?mirror_xyz_x(lid_tab_void_points):lid_tab_void_points,
                        trap_prism_vertices,lid_tab_round);
            }
    } 
}

module sanity_check_circuit ()
{
    color ("yellow",0.25) {
        // draw ciruit board
        translate([box_wall,box_wall,pcb_top_z-pcb_thickness])
            cube([pcb_width,pcb_length,pcb_thickness]);
        // draw MIDI jacks
        for (x=midi_jack_center_x) {
            translate([x-midi_jack_width*0.5,box_length-box_wall-midi_jack_depth,pcb_bottom_z-midi_jack_height])
                cube([midi_jack_width,midi_jack_depth,midi_jack_height]); 
        }
        // draw DC jack
        translate([dc_jack_center_x-dc_jack_width*0.5,
                   box_length-box_wall-dc_jack_intrusion,
                   dc_jack_center_z-dc_jack_height*0.5])
        cube([dc_jack_width,dc_jack_depth,dc_jack_height]);
    }
}

// The box
color ("green",0.25) {
    difference () {
        union () {
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
}

// The lid
*color ("green",0.25) {
    difference () {
        lid_solid();
        tab_void ();
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

module sanity_check_z () {
    translate([-5,-5,0])
    cube([10,10,inner_box_wall_z]);
}

sanity_check_circuit();
//sanity_check_width();
//sanity_check_height();
//sanity_check_z();
