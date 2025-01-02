--- @class Gameplay
local Gameplay = Class("Gameplay", Screen)

local FunkyAnimatedSprite = require("game.objects.funkyanimatedsprite")

function Gameplay:enter()
    local sprite = FunkyAnimatedSprite:new(480, 250)
    sprite:loadSparrowAtlas("game/characters/BOYFRIEND", {
        { "idle", "BF idle dance", 24, true }
    })
    --sprite:worldCenter(Enums.Axis.XY)
    sprite:playAnimation("idle")
    self:add(sprite)
end

return Gameplay