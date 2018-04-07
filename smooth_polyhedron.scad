// Make a cube out of the convex hull of 8 points. The points are moved toward
// the center so that the sides of the cube agree with the dimensions given
// w - width
// l - length
// h - height
// r - corner radius
module rounded_cube(w,l,h,r,center=false) {
    hull () {
        for (p=[
                [r,r,r],
                [r,r,h-r],
                [r,l-r,r],
                [r,l-r,h-r],
                [w-r,r,r],
                [w-r,r,h-r],
                [w-r,l-r,r],
                [w-r,l-r,h-r]
                ]) {
            if (center) {
                translate(p-[w*0.5,l*0.5,h*0.5])
                    sphere(r);
            } else {
                translate(p)
                    sphere(r);
            }
        }
    }
}

$fn=20;

rounded_cube(10,20,30,5,center=true);
