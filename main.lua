require("engine.util.override")
require("engine.util.import")

AssetManager = require("game.backend.assetmanager")

function love.load()
    love.audio.setVolume(0.1)
    ScreenManager:initialize()
    ScreenManager:addOverlay(require("game.objects.perfcounter"):new(5, 5))
    ScreenManager:switchScreen("game.screens.menu")
end

function love.update(dt)
    GlobalUpdate(dt)
    ScreenManager:update(dt)
end

function love.errorhandler(msg)
    return function()
        print(msg)
        --throw.error() -- error, throw is nil
        return 1
    end
end

function love.keypressed(key, scancode, isrepeat)
    ScreenManager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    ScreenManager:keyreleased(key)
end

function love.draw()
    love.graphics.push("all")
    --[[local camera = ScreenManager:getCamera()
    if camera then
        -- TODO: fix this cus it doesn't work
        love.graphics.setColor(camera.tint)
        love.graphics.applyTransform(camera:getTransform())
    end]]
    ScreenManager:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end
