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

function vadd(points,point)=[for(p=points)p+point];
function vmulc(points,c)=[for(p=points)p*c];
function sum(list, idx = 0, result = 0) = 
	idx >= len(list) ? result : sum(list, idx + 1, result + list[idx]);
function midpoint(points)=sum(points,result=[0,0,0])/len(points);
function normalize(p)=p/norm(p);
function normalize_l(ps)=[for(p=ps)normalize(p)];
// The projection of A onto B
function proj_v(A,B)=(A*B)/(B*B)*B;
// vectorized indexing
function index_v(p,i)=[for(i_=i)p[i_]];

// returns the point of the sphere sitting in the corner desribed by these
// points
function rounded_3d_inside_corner(
    center, // the point the bisector exits from
    points, // the points that are connected to the center point
    r, // radius of circle at corner
)=
let(
   points_=normalize_l(vadd(points,-center)),
   M=midpoint(points_),
   N=cross(points_[0],points_[1]),
   a=r/norm(M-(M-proj_v(M,N)))
   //why this doesn't work, I don't know
   //proj_v(M,points_[0])+proj_v(M,points_[1])), shouldn't it be the same as
   //projecting onto the plane spanned by points_[0] and points_[1] ?
)a*M+center;
//sum(vmulc(points_,r),result=[0,0,0])+center;//a*M+center;

module rounded_convex_polyhedron(
    points, // the points in the polygon
// a list of lists containing indices of the points each point is connected to by an edge
// i.e., the list at the 0th index lists the indices of the points the 0th point
// is connected to
    point_idx,
    r, // radius of circles at corner
) {
    hull () {
        for (i=[0:len(points)-1]) {
            echo(index_v(points,point_idx[i]));
            translate(rounded_3d_inside_corner(points[i],index_v(points,point_idx[i]),r))
                sphere(r);
        }
    }
}

$fn=10;
//for (i=[1:5]) {
//    rounded_convex_polygon([[1,6],[1,1],[2,1],[3,4]],i*0.05,i);
//}
//tetra_points=[[1,1,1],[1,-1,-1],[-1,1,-1],[-1,-1,2]];
tetra_points=[[0,0,0],[-1,0,0],[0,-1,0],[0,0,-1]];
        rounded_convex_polyhedron(
                tetra_points,
                [[1,2,3],[0,2,3],[0,1,3],[0,1,2]],
                0.01);

box_points=[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]];
*rounded_convex_polyhedron(
        vmulc(box_points,1),
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        0.1);

top_s=0.3;
trap_points=[[0,0,0],[top_s,top_s,1],[0,1,0],[top_s,1-top_s,1],[1,0,0],[1-top_s,top_s,1],[1,1,0],[1-top_s,1-top_s,1]];
rounded_convex_polyhedron(
        vmulc(trap_points,1),
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        0.1);
polyhedron(
        [[0,0,0],[0,0,1],[1,0,0],[1,0,1],[0,top_s,1],[1,top_s,1]],
        faces=[[0,1,3,2],[0,1,4],[2,3,5],[0,2,5,4],[1,3,5,4]]);
translate([-1,0,0]) cube([1,1,1]);
translate([0,-1,0]) cube([1,1,1]);
