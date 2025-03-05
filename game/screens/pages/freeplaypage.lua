--- @class FreeplayPage
local FreeplayPage, super = Class("FreeplayPage", Canvas)

local selected = 1

function FreeplayPage:enter()
    local background = Sprite:new(0, 0)
    background.texture = love.graphics.newImage("res/ui/menu/menuDesat.png")
    background.tint = { love.math.tintFromBytes(66, 135, 245) }
    self:add(background)
    self:changeSelection()
end

function FreeplayPage:keypressed(_)
    local axis = Input.axis("ui_up", "ui_down")
    if axis ~= 0 then self:changeSelection(axis) end
    if Input.down("ui_confirm") then
        Sound.playSfx("res/sounds/confirmMenu.ogg", "static")
        self:close()
    end
end

function FreeplayPage:changeSelection(next)
    next = next or 0
    selected = math.wrapvalue(selected + next, 1, 1)
    if next ~= 0 then
        Sound.playSfx("res/sounds/scrollMenu.ogg", "static")
    end
end

function FreeplayPage:close()
    return super.dispose(self)
end

return FreeplayPage
