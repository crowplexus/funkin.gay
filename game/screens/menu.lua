--- @class Menu
local Menu, super = Class("Menu", Screen)
local FunkyAnimatedSprite = require("game.objects.funkyanimatedsprite")
local FreeplayPage = require("game.screens.pages.freeplaypage")

local activePage = nil
local selected = 1

local buttons = {
    { "storymode", function() end },
    { "freeplay",  function() end },
    { "options",   function() end },
    { "credits",   function() end },
}
local groupButtons = {}

function Menu:enter()
    Sound.playMusicPassive(AssetManager.getPath("music/menu/freakyMenu.ogg"), "stream", 0.3, true)
    Sound.setLooping(true)

    local background = Sprite:new(0, 0)
    background.texture = AssetManager.getImage("ui/menu/menuBG")
    self:add(background)

    for i = 1, #buttons do
        local id = buttons[i][1]
        local button = FunkyAnimatedSprite:new(0, (160 * i) - 85)
        button:loadSparrowAtlas("res/ui/menu/main/" .. id)
        button:addAnimationFromPrefix("idle", id .. " idle", 5, true)
        button:addAnimationFromPrefix("hover", id .. " selected", 5, true)
        button:playAnimation("idle", true)
        button:worldCenter(Enums.Axis.X)
        groupButtons[i] = button
        self:add(button)
    end
    self:changeSelection()
end

function Menu:update(dt)
    super.update(self, dt)
    if activePage and activePage.update then
        activePage:update(dt)
    end
end

function Menu:keypressed(_)
    if activePage then
        if activePage.keypressed then activePage:keypressed(_) end
        if Input.down("ui_cancel") then
            if activePage.close then
                activePage:close()
            end
            self:remove(activePage)
            activePage = nil
        end
    else
        local axis = Input.axis("ui_up", "ui_down")
        if axis ~= 0 then self:changeSelection(axis) end
        if Input.down("ui_confirm") then
            Sound.playSfx("res/sounds/confirmMenu.ogg", "static")
            activePage = FreeplayPage:new()
            self:add(activePage)
            activePage:enter()
        end
    end
end

function Menu:changeSelection(next)
    if activePage and activePage.changeSelection then
        activePage:changeSelection(next)
        return
    end
    next = next or 0
    groupButtons[selected]:playAnimation("idle", true)
    selected = math.wrapvalue(selected + next, 1, #buttons)
    groupButtons[selected]:playAnimation("hover", true)
    groupButtons[selected]:worldCenter(Enums.Axis.X)
    if next ~= 0 then
        Sound.playSfx("res/sounds/scrollMenu.ogg", "static")
    end
end

return Menu
