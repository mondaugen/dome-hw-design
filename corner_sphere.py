import numpy as np
import numpy.linalg as la
import sys

def cross_3(u,v):
    return np.array([
        u[1,:]*v[2,:] - u[2,:]*v[1,:],
        -1*(u[0,:]*v[2,:] - u[2,:]*v[0,:]),
        u[0,:]*v[1,:] - u[1,:]*v[0,:],
    ])

def is_acute(a,b):
    """ Returns 1 if angle between a and b obtuse -1 otherwise.
        a and b must be column vectors. """
    if (a.T*b)/(la.norm(a)*la.norm(b)) >= 0:
        return 1
    else:
        return -1


if len(sys.argv) < 5:
    sys.stderr.write("args are A B C r\n")
    sys.exit(1)

A=np.c_[eval(sys.argv[1])]
B=np.c_[eval(sys.argv[2])]
C=np.c_[eval(sys.argv[3])]
r=eval(sys.argv[4])

# if we use i, j, k with i vector colinear to x-axis, j, k colinear to y, z,
# then b must be reversed or else will point in wrong direction
#a=cross_3(A,B) 
#b=-cross_3(A,C)
#c=cross_3(B,C)

# Mid point of all vectors
M=(A+B+C)/3.
a_=np.matrix(cross_3(A,B))
b_=np.matrix(cross_3(A,C))
c_=np.matrix(cross_3(B,C))

a=a_*is_acute(a_,M)
b=b_*is_acute(b_,M)
c=c_*is_acute(c_,M)

print a
print b
print c
print np.c_[a,b,c].T
u1=la.solve(np.c_[a,b,c].T,np.c_[[la.norm(a),la.norm(b),la.norm(c)]]*r)
#u2=la.solve(np.c_[a,c,b].T,np.c_[[la.norm(a),la.norm(c),la.norm(b)]]*r)

print u1
#print u2
