module rounded_corner(
    point_left,
    point_center,
    point_right,
    r, // radius of circle at corner
    h
) {
    A_=point_left-point_center;
    B_=point_right-point_center;
    A=A_/norm(A_);
    B=B_/norm(B_);
    M=(A+B)*0.5;
    a=r/norm(M-(M*B)/(B*B)*B);
    //echo(a);
    translate(point_center)
        translate(a*M)
            cylinder(r=r,h=h); 
    //polygon([point_left,point_center,point_right]);
}

module rounded_convex_polygon(
    points,
    r,
    h
)
{
    points_=concat([points[len(points)-1]],points,[points[0]]);
    hull () {
        for (i=[0:len(points_)-3]) {
            rounded_corner(points_[i],points_[i+1],points_[i+2],r,h);
        }
    }
}

$fn=20;
for (i=[1:5]) {
    rounded_convex_polygon([[1,6],[1,1],[2,1],[3,4]],i*0.05,i);
}
