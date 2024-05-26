local gfx = playdate.graphics
local spriteUpdate <const> = playdate.graphics.sprite.update

local backGround = gfx.image.new('img/gameover')

class('Gameover').extends()
function Gameover:init()
    if (score>highscore) then
        highscore = score
        saveGameData()
    end
    FadeModule:init()
    FadeModule:setup1()
    self:draw()
    FadeModule:setup2()
    gameState="gameover"

end

function Gameover:update()
    if (playdate.buttonJustPressed("a") or playdate.buttonJustPressed("b")) then
        TitleScreen:initFade()
    end 
    
end

function Gameover:draw()
    backGround:draw(0, 0)
    myFont:drawTextAligned("score\n\n\n\nhighscore",200,100,kTextAlignment.center)
    myFont:drawTextAligned(score,200,125,kTextAlignment.center)
    myFont:drawTextAligned(highscore,200,200,kTextAlignment.center)
end



