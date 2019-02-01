use <rounded_polygon.scad>
use <common.scad>


$fn=30;
    
echo("hihi ",rounded_corner_centers([[0,0,0],[1,0,0],[1,1,0],[0,1,0]],0.1));
//rounded_convex_polygon([[0,0,0],[1,0,0],[1,1,0],[0,1,0]],0.1,1);
hollow_rounded_convex_polygon([[0,0,0],[1,0,0],[1,1,0],[0,1,0]],0.1,1,0.05);

//rounded_shaft(
//[0.5,0.5,0.5],
//[.9,.9,.9],
//.05,
//.1);
