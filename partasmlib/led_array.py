import partasm as pa
import led
# A grid of leds

class led_array_t(pa.cube_t):

    def __init__(self,coords=(0,0,0),nrows=1,ncols=1,gapx=1,gapy=1):
        self.leds=[]
        for r in range(nrows):
            y_coord=gapy*(r+1)+led.length*r
            for c in range(ncols):
                x_coord=gapx*(c+1)+led.width*c
                self.leds.append(
                        led.led_t(
                            coords=(coords[0]+x_coord,coords[1]+y_coord,coords[2])))
        pa.cube_t.__init__(self,coords=coords,
                dims=(
                    gapx*(ncols+1)+led.width*ncols,
                    gapy*(nrows+1)+led.length*nrows,
                    led.height))

    def translate(self,coords):
        pa.cube_t.translate(self,coords)
        for l in self.leds:
            l.translate(coords)

    def oscad_draw_solid(self):
        s=""
        for l in self.leds:
            s += l.oscad_draw_solid() + "\n"
        return s
