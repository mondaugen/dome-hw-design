module weird_shape () {
linear_extrude(height=1) {
polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
}}

hull () {
weird_shape();
translate ([-1,-1,-1]) cylinder(r=0.1,h=0.1);
translate ([6,6,-1]) cylinder(r=0.1,h=0.1);
}

translate([10,10,10]) weird_shape();
