import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"

local gfx = playdate.graphics
local screenImage = gfx.image.new(400, 240)

class('FadeModule').extends()
function FadeModule:init()
    self.fade = 1
    self.finish = 1
end
function FadeModule:setup1()
    gfx.lockFocus(screenImage)
end
function FadeModule:setup2()
    gfx.unlockFocus()
    self:startFade()
end

function FadeModule:startFade()
    self.fade = 0
    self.finish = 0
end

function FadeModule:updateFade(speed)
    if (self.finish==0) then
        if (self.fade<1) then
            self.fade = self.fade+(1/speed)
        else
            self.finish = 1
        end
        screenImage:scaledImage(self.fade):drawCentered(200,120)
    end
end

