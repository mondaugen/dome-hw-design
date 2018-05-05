use <common.scad>
$fn=30;
wall_thickness=2;
corner_r=2;
///difference(){
///rounded_square([0,0,0],[10+wall_thickness,10+wall_thickness,10],wall_thickness*0.5+corner_r);
///rounded_square([0,0,0],[10,10,10+1e-2],corner_r);
///}
rounded_shaft([0,0,0],[10,10,10],corner_r,wall_thickness);
