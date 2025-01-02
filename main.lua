require("engine.util.override")
require("engine.util.import")

AssetManager = require("game.backend.assetmanager")

local overlays = {
    require("game.objects.perfcounter"):new(5, 5)
}

function love.load()
    love.audio.setVolume(0.1)
    ScreenManager:initialize()

    -- TODO: make a better system for all this
    ScreenManager:addScreen(require("game.screens.menu"):new(), "menu")
    ScreenManager:addScreen(require("game.screens.gameplay"):new(), "gameplay")
    ScreenManager:switchScreen("gameplay")
end

function love.update(dt)
    GlobalUpdate(dt)
    ScreenManager:update(dt)
end

function love.errorhandler(msg)
    return function()
        print(msg)
        throw.error() -- error, throw is nil
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
    if ScreenManager.activeScreen.camera then
        -- TODO: fix this cus it doesn't work
        love.graphics.setColor(ScreenManager.activeScreen.camera.color)
        love.graphics.applyTransform(ScreenManager.activeScreen.camera:getTransform())
    end
    ScreenManager:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
    for _, overlay in pairs(overlays) do
        if overlay.draw then overlay:draw() end
    end
end
