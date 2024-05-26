import "CoreLibs/ui"

local gfx = playdate.graphics

local image = gfx.image.new('img/systemmenu')

function removeSysMenu()
    local menu = playdate.getSystemMenu()
    menu:removeAllMenuItems()
end

function sysMenuGame()
    local menu = playdate.getSystemMenu()
    playdate.setMenuImage(image)

    local menuItem, error = menu:addMenuItem("Restart", function()
        gfx.clear(gfx.kColorWhite)
        Game:init()
    end)

    local checkmarkMenuItem, error = menu:addMenuItem("Menu", function(value)
        TitleScreen:initFade()
    end)
end

function sysMenuTitle()
    local menu = playdate.getSystemMenu()
    playdate.setMenuImage(image)

    local menuItem, error = menu:addMenuItem("Start", function()
        Game:init()
    end)

end