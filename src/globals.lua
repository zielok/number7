import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "CoreLibs/ui"
import "CoreLibs/easing"
import "CoreLibs/crank"
import "CoreLibs/nineslice"

import 'title.lua'
import 'instruction.lua'
import 'game.lua'
import 'gameover.lua'
import 'sysmenu.lua'
import 'sfx.lua'
import 'fademodule.lua'

local gfx = playdate.graphics
local sfx = playdate.sound.sampleplayer
local msx = playdate.sound.fileplayer

function drawBackgroundImage(backGround)
    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            gfx.setClipRect( x, y, width, height ) -- just draw what we need
            backGround:draw( 0, 0 )
            gfx.clearClipRect()
        end
    )
end

highscore = 0

function saveGameData()
    local gameData = {
        hscore = highscore
    }
    playdate.datastore.write(gameData)
end

local gameData = playdate.datastore.read()
if gameData then
    highscore = gameData.hscore
end

--[[todo
]] 

--[[
help

Paint image table
ImagesTab = playdate.graphics.imagetable.new(images)
ImagesTab:drawImage(im,x,y)

load image
Image1 = gfx.image.new('img/1.png')

draw background with sprite engine
self.image = gfx.image.new('img/game')
        gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            gfx.setClipRect( x, y, width, height ) -- just draw what we need
            self.image:draw( 0, 0 )
            gfx.clearClipRect()
        end
    )

button
playdate.buttonJustPressed("a")
playdate.buttonIsPressed("left")

remove sprites
playdate.graphics.sprite.removeAll()
]]--

