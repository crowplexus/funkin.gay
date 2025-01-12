--- @class Gameplay
local Gameplay, super = Class("Gameplay", Screen)

local FunkyAnimatedSprite = require("game.objects.funkyanimatedsprite")

function Gameplay:enter()
    local camera = Camera:new(0, 0)
    camera.color = { love.math.colorFromBytes(255, 0, 0, 10) }
    camera.limit = Rect2(-500, -500, 500, 500)
    self:add(camera)
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
    local movspeed = 800
    local rotspeed = 0.5
    local camera = self:getCamera()
    if Input.down("ui_left") then camera.position.x = camera.position.x - movspeed * dt end
    if Input.down("ui_right") then camera.position.x = camera.position.x + movspeed * dt end
    if Input.down("ui_up") then camera.position.y = camera.position.y - movspeed * dt end
    if Input.down("ui_down") then camera.position.y = camera.position.y + movspeed * dt end
    if love.keyboard.isDown("q") then
        camera.zoom.x = camera.zoom.x + 1.0 * dt
        camera.zoom.y = camera.zoom.y + 1.0 * dt
    end
    if love.keyboard.isDown("e") then
        camera.zoom.x = camera.zoom.x - 1.0 * dt
        camera.zoom.y = camera.zoom.y - 1.0 * dt
    end
    --camera.rotation = camera.rotation + rotspeed * dt
end

return Gameplay