// Find coordinates of sphere placed in corner

// Return 1 if angle between vectors less than pi, -1 otherwise
function _is_acute(u,v)=
    u*v/(norm(u)*norm(v)) >= 0 ? 1 : -1;

// Find inverse of 3 x 3 matrix
function _inv_3x3(X)=
let (
a=X[0][0],
b=X[0][1],
c=X[0][2],
d=X[1][0],
e=X[1][1],
f=X[1][2],
g=X[2][0],
h=X[2][1],
i=X[2][2],
A = (e*i-f*h)  ,
D = -(b*i-c*h) ,
G = (b*f-c*e)  ,
B = -(d*i-f*g) ,
E = (a*i-c*g)  ,
H = -(a*f-c*d) ,
C = (d*h-e*g)  ,
F = -(a*h-b*g) ,
I = (a*e-b*d)  ,
detA=a*A+b*B+c*C) 
[[A,D,G],[B,E,H],[C,F,I]]/detA;

// Pack vectors into a column matrix
function _col_pack_3x3(a,b,c)=
[
[a[0],b[0],c[0]],
[a[1],b[1],c[1]],
[a[2],b[2],c[2]],
];

// Returns coordinates of sphere placed in corner
function corner_sphere(A,B,C,r)=
let (
M=(A+B+C)/3.,
a_=cross(A,B),
b_=cross(A,C),
c_=cross(B,C),
a=a_*_is_acute(a_,M),
b=b_*_is_acute(b_,M),
c=c_*_is_acute(c_,M),
X=[a,b,c]) // no need to transpose it seems
_inv_3x3(X)*(r*[norm(a),norm(b),norm(c)]);

// For testing, specify A B C r on command line
echo(corner_sphere(A,B,C,r));
