import itertools
import sys
# Routines for assembling parts together

class point_t:

    """
    A point in 3D space.
    """

    def __init__(self,x,y,z):
        self.x=x
        self.y=y
        self.z=z

    def as_tuple(self):
        return (self.x,self.y,self.z)

    def __add__(self,other):
        if isinstance(other,point_t):
            return point_t(self.x + other.x,
                self.y + other.y,
                self.z + other.z)
        else:
            return NotImplemented

    def __string__(self):
        return "({self.x},{self.y},{self.z})".format(self=self)

class part_t:

    def __init__(self,coords=(0,0,0)):
        self.translation=point_t(*coords)

    def get_dims(self):
        """
        Should return a point whose coordinates represent the object's size in
        that dimension.
        """
        return NotImplemented

    def get_local_rect_points(self):
        return NotImplemented

    def get_rect_points(self):
        points=self.get_local_rect_points()
        return [p + self.translation for p in points]

    def translate(self,coords):
        self.translation += point_t(*coords)

    def oscad_draw_solid(self):
        """
        Draw the object that will be unioned with the rest of the drawing.
        """
        return NotImplemented

    def oscad_draw_void(self):
        """
        Draw the object that will be subtracted from the rest of the drawing.
        """
        return NotImplemented

def convert_to_gap_dict(gap):
    """
    A gap dict is a dictionary with the keys 'n','s','e','w','t','b' where each
    value specifies the gap on the north, south, east, west, top or bottom side
    respectively.
    
    This function makes it easy to create a gap dict from different kinds of
    values.

    If gap is a single number then a gap dictionary is made where each entry is
    equal to that number.

    If gap is a tuple t, then 'n','s' = t[1], 'e','w'=t[0], 't','b'=t[2].

    Otherwise, if not a dictionary with the right keys, this function fails.
    """
    keys=['n','s','e','w','t','b']
    if isinstance(gap,type(int())) or isinstance(gap,type(float())):
        d=dict()
        for k in keys:
            d[k] = gap
        return d
    if isinstance(gap,type(dict())) and (set(gap.keys()) == set(keys)):
        return gap
    d=dict()
    d['n'] = gap[1]
    d['s'] = gap[1]
    d['e'] = gap[0]
    d['w'] = gap[0]
    d['t'] = gap[2]
    d['b'] = gap[2]
    return d

class cube_t(part_t):

    """
    More a rectangular prism than a cube but cube is easier to write.
    dims is the size of the actual cube
    gap is added to dims when get_dims() is called so that the gap is taken into
    account when packing the shape with other parts.
    when drawn the cube is the size of dims + the gap in each dimension
    """

    def __init__(self,coords=(0,0,0),dims=(1,1,1),gap=0):
        part_t.__init__(self,coords)
        self.gap=convert_to_gap_dict(gap)
        # Dimesions of the actually drawn cube
        self.dims=dims

    def get_dims(self):
        """
        Dimensions of the cube and the gap around it.
        """
        ret = point_t(*self.dims)
        ret.x += self.gap['e'] + self.gap['w']
        ret.y += self.gap['n'] + self.gap['s']
        ret.z += self.gap['t'] + self.gap['b']
        return ret

    def get_local_rect_points(self):
        dims = self.get_dims()
        return [point_t(*p) for p in itertools.product(
            [0,dims.x],
            [0,dims.y],
            [0,dims.z])]

    def get_trans_to_solid(self):
        gap_trans=[self.gap[k] for k in ['w','s','b']]
        return self.translation + point_t(*gap_trans)

    def oscad_draw_solid(self):
        gap_trans=self.get_trans_to_solid()
        return(
"""
    translate([{gap_trans.x},{gap_trans.y},{gap_trans.z}])
    cube([{dims[0]},{dims[1]},{dims[2]}]);
""".format(self=self,dims=self.dims,gap_trans=gap_trans))

    def oscad_draw_void(self):
        return ""

def extreme_points(points,corner=(None,None,None),dims=(None,None,None)):
    # Filter out points not in cube described by corner and dims
    for c,d,co in zip(corner,dims,['x','y','z']):
        if c and d:
            points=filter(lambda p: c <= getattr(p,co) <= (c+d),points)
            points = list(points)
    if not points:
        return (None,None)
    # Find extreme points in thurrr
    mins=tuple([sorted(points,key=lambda p: getattr(p,co))[0] for co in
        ['x','y','z']])
    maxs=tuple([sorted(points,key=lambda p: getattr(p,co))[-1] for co in
        ['x','y','z']])
    return (mins,maxs)


sticky_dims={
    # dimension indices, dimension names, include part dimension or not
    'e':(1,2,'y','z',0),
    'w':(1,2,'y','z',1),
    'n':(0,2,'x','z',0),
    's':(0,2,'x','z',1),
    't':(0,1,'x','y',0),
    'b':(0,1,'x','y',1),
}

def _sd_get_corner(ep,part,pos,align,points,useconvexhull):

    corner=[None,None,None]
    a,b,ac,bc,pd=sticky_dims[pos]

    for p,q in zip([a,b],[ac,bc]):
        if align[p] == '-':
            corner[p] = getattr(ep[0][p],q)
        elif align[p] == '+':
            corner[p] = getattr(ep[1][p],q)-getattr(part.get_dims(),q)
        elif align[p] == '.':
            # TODO: This doesn't work because there isn't guaranteed to be
            # points in the rectangular prism going through the center of a
            # shape
            corner[p] = (getattr(ep[0][p],q)+getattr(ep[1][p],q)-getattr(part.get_dims(),q))*0.5
        else:
            raise Exception('Unknown alignment %s' % (align[p],))

    p=list(set([0,1,2])-set([a])-set([b]))[0]
    q=list(set(['x','y','z'])-set([ac])-set([bc]))[0]
    sys.stderr.write("corner: "+str(corner)+'\n')
    sys.stderr.write("p: "+str(p)+'\n')
    sys.stderr.write("q: "+str(q)+'\n')
    sys.stderr.write("part.dims: "+str(part.get_dims().as_tuple())+'\n')
    if useconvexhull:
        corner[p]=getattr(extreme_points(points)[1-pd][p]
                ,q)-pd*getattr(part.get_dims(),q)
    else:
        corner[p]=getattr(extreme_points(points,
            corner,part.get_dims().as_tuple())[1-pd][p],q)-pd*getattr(part.get_dims(),q)

    return corner

def stick_on_part(
        parts,
        part,
        pos,
        align,
        useconvexhull):

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
    mi,ma=ep
    sys.stderr.write("min\n")
    for m in mi:
        sys.stderr.write(m.__string__()+'\n')
    sys.stderr.write("max\n")
    for m in ma:
        sys.stderr.write(m.__string__()+'\n')
    corner=_sd_get_corner(ep,part,pos,align,points,useconvexhull)

    part.translate(corner)
    return parts + [part]

def parts_hull(parts):
    """
    Find the (rectangularly-prismic) hull of the parts.
    Returns a tuple of 2 point_t. First is the bottom corner of the hull, second
    represents its dimensions.
    """
    points=[]
    for p in parts:
        points += p.get_rect_points()
    ep=extreme_points(points)
    return (
        point_t(ep[0][0].x,ep[0][1].y,ep[0][2].z),
        point_t(ep[1][0].x-ep[0][1].x,
            ep[1][1].y-ep[0][1].y,
            ep[1][2].z-ep[0][2].z))
