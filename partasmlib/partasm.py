# Routines for assembling parts together

class point_t:

    """
    A point in 3D space.
    """

    def __init__(self,x,y,z):
        self.x=x
        self.y=y
        self.z=z

    def __add__(self,other):
        if isinstance(other,point_t):
            return point_t(self.x + other.x,
                self.y + other.y,
                self.z + other.z)
        else:
            return NotImplemented

class part_t:

    def __init__(self,coords=(0,0,0)):
        self.translation=point_t(*coords)

    def get_local_rect_points(self):
        return NotImplemented

    def get_rect_points(self):
        points=self.get_local_rect_points()
        return [p + self.translation for p in points]

    def translate(self,coords):
        self.translate += point_t(*coords)

    def oscad_draw(self):
        return NotImplemented

class cube_t(part_t)

    """
    More a rectangular prism than a cube but cube is easier to write.
    """

    def __init__(self,coords=(0,0,0),dims=(1,1,1)):
        part_t.__init__(self,coords)
        self.dims=point_t(dims)

    def get_local_rect_points(self):
        return [point_t(p) for p in itertools.product(
            [self.translation.x,self.translation.x+self.dims.x],
            [self.translation.y,self.translation.y+self.dims.y],
            [self.translation.z,self.translation.z+self.dims.z])]

    def oscad_draw(self):
        return(
"""
translate([{self.translation.x},{self.translation.y},{self.translation.z}])
    cube([{self.dims.x},{self.dims.y},{self.dims.z}]);
""".format(self=self))


def extreme_points(points,corner=(None,None,None),dims=(None,None,None)):
    # Filter out points not in cube described by corner and dims
    for c,d,co in zip(corner,dims,['x','y','z']):
        if c and d:
            points=filter(lambda p: c <= getattr(p,co) <= (c+d),points)
    # Find extreme points in thurrr
    mins=tuple([sorted(points,key=lambda p: getattr(p,co))[0] for co in
        ['x','y','z']])
    maxs=tuple([sorted(points,key=lambda p: getattr(p,co))[-1] for co in
        ['x','y','z']])
    return (mins,maxs)


sticky_dims={
    # dimension indices, dimension names, include part dimension or not
    'e':(1,2,'y','z',0)
    'w':(1,2,'y','z',1)
    'n':(0,2,'x','z',0)
    's':(0,2,'x','z',1)
    't':(0,2,'x','z',0)
    'b':(0,2,'x','z',1)
}

def _sd_get_corner(ep,part,pos,align,points):

    corner=(None,None,None)
    a,b,ac,bc,pd=sticky_dims[pos]

    for p,q in zip([a,b],[ac,bc]):
        if align[p] == '-':
            corner[p] = getattr(ep[0][p],q)
        elif align[p] == '+'
            corner[p] = getattr(ep[1][p],q)
        elif align[p] == '.':
            corner[p] = getattr(ep[0][p],q)+getattr(ep[1][p],q)-getattr(part.dims,q)
        else:
            raise Exception('Unknown alignment %s' % (align[p],))

    p=list(set([0,1,2])-set([a])-set([b]))[0]
    q=list(set(['x','y','z'])-set([ac])-set([bc]))[0]
    if useconvexhull:
        corner[p]=extreme_points(points)[1-pd][p].x-pd*part.dims.x
    else:
        corner[p]=extreme_points(points,corner,part.dims)[1-pd][p].x-pd*part.dims.x

    return corner

def stick_on_part(
        parts,
        part,
        pos,
        align,
        useconvexhull,
        gap):

    """
    "parts" is used to get a collection of points that describe the locally
    extreme points, relative to which we will place "part"

    "pos" is one of n,s,e,w,t,b, which are north,south,east,west,top,bottom
    respectively. This describes on which side to "stick" the part.

    "align" is where to align the part on that side. This is a 3-tuple where
    each entry is one of +,-,. . + means align to the positive extreme of the
    dimension (according to the points from parts limited by the extent of
    part), - means align to the negative extreme and . means align to the middle
    of the positive and negative extremes of that dimension. The dimension
    corresponding to the "pos" variable is ignored. For example if you choose
    pos=e then the first dimension is ignored because this function is trying to
    determine where to place the part in the x dimension. So a viable tuple for
    this case is ('','-','+') which would try and align the part with the top
    edge of the shape (the most positive edge in the z dimension) and the most
    negative edge in the y dimension

    "useconvexhull", if true, means use the rectangular prism described by all
    of parts, not just the extreme points relevant to the part. For example, if
    the parts describe an L-shape, the new part will not be placed in the inside
    corner described by the L, even if the part would fit. if "useconvexhull" is
    false, then it could be placed in this corner if it fits and that position
    is requested

    "gap" is the amount of space to leave between the new part and the parts
    """

    points=[]
    for p in parts:
        points += p.get_rect_points()

    ep=extreme_points(points)
    corner=_sd_get_corner(ep,part,pos,align,points)

    part.translate(corner)
    return parts + [part]

p1=point_t(1,2,3)
p2=point_t(1,-1,2)
p3=p1+p2
print("x=%f y=%f z=%f" % (p3.x,p3.y,p3.z))
