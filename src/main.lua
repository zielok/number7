import 'globals.lua'

local gfx = playdate.graphics

gameState = "initmenu"
--playdate.display.setRefreshRate(0)

FadeModule:init()
TitleScreen:init()
function playdate.update()
    gfx.setBackgroundColor(gfx.kColorClear)
    --gfx.clear()

    if (gameState=="menu") then
        FadeModule:updateFade(15)
        if (FadeModule.finish==1) then
            TitleScreen:update()
            TitleScreen:draw()
        end
    elseif (gameState=="instruction") then
        FadeModule:updateFade(15)
        if (FadeModule.finish==1) then
            Instruction:draw()
            Instruction:update()
        end
    elseif (gameState=="game") then
        --playdate.resetElapsedTime()
        FadeModule:updateFade(15)
        if (FadeModule.finish==1) then
            Game:draw()
            Game:update()
            --Gameover:init()
        end
    elseif (gameState=="gameover") then
        FadeModule:updateFade(15)
        if (FadeModule.finish==1) then
            Gameover:draw()
            Gameover:update()
        end
    end
    

    --playdate.drawFPS()
end

function playdate.BButtonHeld()
end

function playdate.cranked()
    
end

function playdate.gameWillTerminate()
    saveGameData()
end

function playdate.deviceWillSleep()
    saveGameData()
end

function playdate.gameWillPause()
    saveGameData()
end

function playdate.keyPressed(key)

end

