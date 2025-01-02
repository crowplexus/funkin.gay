--- @class Gameplay
local Gameplay, super = Class("Gameplay", Screen)

local FunkyAnimatedSprite = require("game.objects.funkyanimatedsprite")

local camera = nil

function Gameplay:enter()
    self.camera = Camera:new(0, 0)
    self.camera.color = { love.math.colorFromBytes(255, 0, 0, 10) }
    self.camera.zoom.x = 0.5
    camera = self.camera
    for i = 1, 5 do
        local sprite = FunkyAnimatedSprite:new(480 - (50 * i), 250)
        sprite:loadSparrowAtlas("game/characters/BOYFRIEND", {
            { "idle", "BF idle dance", 24, true }
        })
        --sprite:worldCenter(Enums.Axis.XY)
        sprite:playAnimation("idle")
        self:add(sprite)
    end
end

function Gameplay:update(dt)
    super.update(self, dt)
    local speed = 0.1
    if Input.down("ui_left") then camera.position.x = camera.position.x + speed * dt end
    if Input.down("ui_right") then camera.position.x = camera.position.x - speed * dt end
    if Input.down("ui_up") then camera.position.y = camera.position.y + speed * dt end
    if Input.down("ui_down") then camera.position.y = camera.position.y - speed * dt end
    camera.rotation = camera.rotation + speed * dt
end

return Gameplay