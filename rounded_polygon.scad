use <corner_sphere.scad>

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

// The center of the circle given by rounded corner
function rounded_corner_center(
    point_left,
    point_center,
    point_right,
    r // radius of circle at corner
    )=
    let(
    A_=point_left-point_center,
    B_=point_right-point_center,
    A=A_/norm(A_),
    B=B_/norm(B_),
    M=(A+B)*0.5,
    a=r/norm(M-1*(M*B)/(B*B)*B)) point_center + a*M;


function rounded_corner_centers(
    points,
    r)=let(
    points_=concat([points[len(points)-1]],points,[points[0]]))
        [for (i=[0:len(points_)-3])rounded_corner_center(points_[i],points_[i+1],points_[i+2],r)];
    

module rounded_corner(
    point_left,
    point_center,
    point_right,
    r, // radius of circle at corner
    h
) {
    translate(rounded_corner_center(point_left,point_center,point_right,r))
            cylinder(r=r,h=h); 
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

module _polygon_corners(
    points,
    r,
    h
)
{
    points_=concat([points[len(points)-1]],points,[points[0]]);
    for (i=[0:len(points_)-3]) {
        rounded_corner(points_[i],points_[i+1],points_[i+2],r,h);
    }
}

//allows removing the center with a constant wall width
//note the minimum radius of the inner polygon's corners is 1e-3
module hollow_rounded_convex_polygon(
points,
r,
h,
w,
test=false)
{
    inner_centers=rounded_corner_centers(points,r);
    inner_r=max(r-w,1e-3);
    if (test) {
        _polygon_corners(
            points,
            r,
            h
        );
        for (point=inner_centers) {
            translate(point) cylinder(r=inner_r,h=2*h);
        }
    } else {
        difference () {
            rounded_convex_polygon(points,r,h);
            hull () {
                for (point=inner_centers) {
                    translate(point) cylinder(r=inner_r,h=h);
                }
            }
        }
    }
}

// returns the point of the sphere sitting in the corner desribed by these
// points
// NOTE: If there's not enough "room" inside of the polygon, the sphere will
// protrude, there's nothing this can do about it
// TODO: Not sure if this works for more than 3 points
// NOTE: If the cross product between the first 2 points (or any points really)
// is [0,0,0], then the result is undefined (divide by 0 basically).
function rounded_3d_inside_corner(
    center, // the point the bisector exits from
    points, // the points that are connected to the center point
    r, // radius of circle at corner
)=
let(
   //points_=normalize_l(vadd(points,-center))
   points_=vadd(points,-center)
//   M=midpoint(points_),
//   N=cross(points_[0],points_[1]),
//   a=r/norm(M-(M-proj_v(M,N)))
   //why this doesn't work, I don't know
   //proj_v(M,points_[0])+proj_v(M,points_[1])), shouldn't it be the same as
   //projecting onto the plane spanned by points_[0] and points_[1] ?
)center+corner_sphere(points_[0],points_[1],points_[2],r);
//sum(vmulc(points_,r),result=[0,0,0])+center;//a*M+center;

// Gives a bunch of spheres describing the outside of the convex hull
// representing a rounded polyhedron
// To make into a polyhedron, simply surround with hull () { ... }
module rounded_convex_set_vertices(
    points, // the points in the polygon
// a list of lists containing indices of the points each point is connected to by an edge
// i.e., the list at the 0th index lists the indices of the points the 0th point
// is connected to
    point_idx,
    r, // radii of circles at corner
    //TODO: Not sure how correct this is if more than 3 edges meet at a vertex
){
        for (i=[0:len(points)-1]) {
            echo(index_v(points,point_idx[i]));
            translate(rounded_3d_inside_corner(points[i],index_v(points,point_idx[i]),r[i]))
                sphere(r[i]);
        }
}

module rounded_convex_polyhedron(
    points, // the points in the polygon
// a list of lists containing indices of the points each point is connected to by an edge
// i.e., the list at the 0th index lists the indices of the points the 0th point
// is connected to
    point_idx,
    r, // radii of circles at corner
    //TODO: Not sure how correct this is if more than 3 edges meet at a vertex
) {
    hull () {
        rounded_convex_set_vertices(points,point_idx,r);
    }
}

module rounded_convex_polyhedron_c(
    points, // the points in the polygon
// a list of lists containing indices of the points each point is connected to by an edge
// i.e., the list at the 0th index lists the indices of the points the 0th point
// is connected to
    point_idx,
    r, // radius of circles at corner
) {
    rounded_convex_polyhedron(points,point_idx,[for(i=[1:len(points)])r]);
}

// Gives a polygon with the rounded polyhedron subtracted out of it
// TODO: This isn't tested, may never work.
module inverse_rounded_convex_polyhedron( points, point_idx, r)
{
   difference () { 
        rounded_convex_polyhedron_c(points,point_idx,1e-3); 
        scale([1.01,1.01,1.01]) rounded_convex_polyhedron(points,point_idx,r);
   }
}

//$fn=10;
//for (i=[1:5]) {
//    rounded_convex_polygon([[1,6],[1,1],[2,1],[3,4]],i*0.05,i);
//}
//tetra_points=[[1,1,1],[1,-1,-1],[-1,1,-1],[-1,-1,2]];
tetra_points=[[0,0,0],[-1,0,0],[0,-1,0],[0,0,-1]];
        rounded_convex_polyhedron_c(
                tetra_points,
                [[1,2,3],[0,2,3],[0,1,3],[0,1,2]],
                0.01);

box_points=[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]];
*rounded_convex_polyhedron_c(
        vmulc(box_points,1),
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        0.1);

top_s=0.3;
trap_points=[[0,0,0],[top_s,top_s,1],[0,1,0],[top_s,1-top_s,1],[1,0,0],[1-top_s,top_s,1],[1,1,0],[1-top_s,1-top_s,1]];
rounded_convex_polyhedron(
        vmulc(trap_points,1),
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        [for(i=[0:len(trap_points)-1])trap_points[i][2]==1?0.1:0.001]);
polyhedron(
        [[0,0,0],[0,0,1],[1,0,0],[1,0,1],[0,top_s,1],[1,top_s,1]],
        faces=[[0,1,3,2],[0,1,4],[2,3,5],[0,2,5,4],[1,3,5,4]]);
translate([-1,0,0]) cube([1,1,1]);
translate([0,-1,0]) cube([1,1,1]);
translate([1,1,0])
rounded_convex_polyhedron_c(
        vmulc(trap_points,1),
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        0.1);
/*
translate([1,0,0])
trap_points_i=[[0,0,0],[top_s-1,top_s,1],[0,1,0],[top_s-1,1-top_s,1],[1,0,0],[1-top_s,top_s,1],[1,1,0],[1-top_s,1-top_s,1]];
inverse_rounded_convex_polyhedron(trap_points,
        [[1,2,4],[0,3,5],[0,3,6],[2,1,7],[0,5,6],[4,7,1],[4,2,7],[3,5,6]],
        [for(i=[0:len(trap_points)-1])trap_points[i][2]==0?0.1:0.001]);
*/
