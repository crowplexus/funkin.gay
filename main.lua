require("engine.util.override")
require("engine.util.import")

AssetManager = require("game.backend.assetmanager")

function love.load()
    love.audio.setVolume(0.1)
    ScreenManager:initialize()

    -- TODO: make a better system for all this
    ScreenManager:addScreen(require("game.screens.menu"):new(), "menu")
    ScreenManager:addScreen(require("game.screens.gameplay"):new(), "gameplay")

    ScreenManager:addOverlay(require("game.objects.perfcounter"):new(5, 5))
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
    if ScreenManager.activeScreen.camera then
        local camera = ScreenManager.activeScreen.camera
        love.graphics.applyTransform(camera:getTransform())
    end
    ScreenManager:draw()
end
