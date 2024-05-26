local gfx = playdate.graphics
local spriteUpdate <const> = playdate.graphics.sprite.update

local backGround = gfx.image.new('img/title')

class('TitleScreen').extends()
function TitleScreen:init()
    drawBackgroundImage(backGround)
    gameState="menu"
    removeSysMenu()
    sysMenuTitle()
end

function TitleScreen:initFade()
    self:init()
    FadeModule:setup1()
    FadeModule:setup1()
    self:draw()
    FadeModule:setup2()       
end

function TitleScreen:update()
    if (playdate.buttonJustPressed("a")) then
        sclick:play()
        Game:init()
    elseif (playdate.buttonJustPressed("b")) then
        sclick:play()
        Instruction:init()
    end 
end
function TitleScreen:draw()
    spriteUpdate()
    --backGround:draw( 0, 0 )
end



