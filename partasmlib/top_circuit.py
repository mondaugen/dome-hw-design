import partasm as pa
import led_array as leda
import encoder as enc
import domepartconfig as dpc
import button as btn

wallgap=dpc.wall_thickness
led_array={
        "n_rows":4,
        "n_cols":10
        }
enc_gap=5

class top_circuit_t(pa.cube_t):

    def __init__(self,ideal_width=0):

        """
        ideal_width: tries to push encoders to the east side so that the width
        is ideal_width, but if it can't, the encoders are just stuck to the east
        side of the LED array.
        """

        self.led_array=leda.led_array_t(
                nrows=led_array['n_rows'],
                ncols=led_array['n_cols'],
                gapx=2,
                gapy=2)
        self.top_encoder=enc.encoder_t()
        self.bottom_encoder=enc.encoder_t()
        self.parts=[self.led_array]

        # Top encoder aligned to top of LED array, right side, trying to be
        # ideal_width
        self.parts=pa.stick_on_part(self.parts,self.top_encoder,'e',('','+','-'),False)
        if (pa.parts_hull(self.parts)[1].as_tuple()[0] + enc_gap) < ideal_width:
            transx = (ideal_width - pa.parts_hull(self.parts)[1].as_tuple()[0] -
                enc_gap)
            self.top_encoder.translate((transx,0,0))

        # Bottom encoder just below
        self.parts=pa.stick_on_part(self.parts,self.bottom_encoder,'s',('+','','-'),False)
        self.bottom_encoder.translate((0,-enc_gap,0))

        # buttons on left side (initially below bottom encoder)
        self.buttons=[btn.button_t() for _ in range(6)]
        self.parts=pa.stick_on_part(self.parts,self.buttons[0],'s',('-','','-'),True)

        # nudge it to make it work
        self.buttons[0].translate((0,-1e-4,0))
        self.parts=pa.stick_on_part(self.parts,self.buttons[1],'e',('','-','-'),False)
        self.parts=pa.stick_on_part(self.parts,self.buttons[2],'s',('-','','-'),True)

        # nudge it to make it work
        self.buttons[2].translate((0,-1e-4,0))
        self.parts=pa.stick_on_part(self.parts,self.buttons[3],'e',('','-','-'),False)

        self.parts=pa.stick_on_part(self.parts,self.buttons[4],'s',('-','','-'),True)
        # nudge it to make it work
        self.buttons[4].translate((0,-1e-4,0))
        self.parts=pa.stick_on_part(self.parts,self.buttons[5],'e',('','-','-'),False)

        # move up to fill in empty space and bring them just below the LED array
        for b in self.buttons:
            b.translate((0,b.get_dims().y,0))

        # move over last 2
        transx = ideal_width - pa.parts_hull(self.buttons[-2:])[1].as_tuple()[0] - enc_gap
        for b in self.buttons[-2:]:
            b.translate((transx,0,0))

        # put shafts around the buttons
        for b in self.buttons:
            self.parts.append(btn.button_shaft(b,inside=True))

        co,dim=pa.parts_hull(self.parts)
        negco=tuple(-1*c for c in co.as_tuple())
        # Make it so bottom corner is at origin
        for p in self.parts:
            p.translate(negco)
        pa.cube_t.__init__(self,coords=co.as_tuple(),dims=dim.as_tuple())

    def oscad_draw_solid(self):
        s=""
        for p in self.parts:
            s += p.oscad_draw_solid() + "\n"
            #s += super(type(p),p).oscad_draw_solid() + "\n"
        
        return s

    def oscad_draw_void(self):
        s=""
        for p in self.parts:
            s += p.oscad_draw_void() + "\n"
        
        return s
 
    def oscad_get_libs(self):
        se=set()
        for p in self.parts:
            se.add(p.oscad_get_libs())
        return "\n".join(se)

    def translate(self,coords):
        pa.cube_t.translate(self,coords)
        for l in self.parts:
            l.translate(coords)

    def get_highest_z(self):
        co,dim=pa.parts_hull(self.parts)
        return co.z+dim.z
