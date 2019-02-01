use <rounded_polygon.scad>

function something (x)=
let(y=x+2,z=sin(y)) x*y;

function vecadd(x)=x+[1,2,3];
function vecaddc(x)=vadd([1,2,3],x);

echo("ans: ", something(123));
echo("ans: ", vecadd([2,4,6]));
echo("ans: ", vecaddc(10));
echo("ans: ", rounded_corner_center(
    [0,1,0],
    [0,0,0],
    [1,0,0],
    0.01
    ));
