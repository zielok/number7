local gfx = playdate.graphics
local spriteUpdate <const> = playdate.graphics.sprite.update

local backGround = gfx.imagetable.new('img/instruction')
myFont = gfx.font.new('img/Sasser-Slab')

class('Instruction').extends()
function Instruction:init()
    self.gameState='page1'
    FadeModule:setup1()
    self:draw()
    FadeModule:setup2()
    gameState="instruction"
end

function Instruction:update()
    if (self.gameState=="page1") then
        if (playdate.buttonJustPressed("a")) then
            sclick:play()
            self.gameState="page2"
            FadeModule:setup1()
            self:draw()
            FadeModule:setup2()
        elseif (playdate.buttonJustPressed("b")) then
            --TitleScreen:initFade()
        end 
    elseif (self.gameState=="page2") then
        if (playdate.buttonJustPressed("a")) then
            sclick:play()
            TitleScreen:initFade()
        elseif (playdate.buttonJustPressed("b")) then
            sclick:play()
            TitleScreen:initFade()
        end 
    end
end

function Instruction:draw()
    if (self.gameState=="page1") then
        backGround:drawImage(1, 0, 0 )
        gfx.drawTextInRect("Move numbered tiles to empty spaces. When you connect three or more identical tiles, you get a tile with a higher number. SEVEN is the final tile. When you connect three final tiles, you receive a bonus. Plan your moves carefully and aim to achieve the highest score.",10,10,380,200,10,true,kTextAlignment.center,myFont)
    elseif (self.gameState=="page2") then
        backGround:drawImage(2, 0, 0 )
    end
end



