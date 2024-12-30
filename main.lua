require("engine.util.override")
require("engine.util.import")

AssetManager = require("game.backend.assetmanager")

local activeScreen = nil
local overlays = {
    -- Framerate Counter
    require("game.objects.perfcounter"):new(5, 5)
}

function love.load()
    love.audio.setVolume(0.1)
    activeScreen = require("game.screens.menu"):new()
    activeScreen:enter()
end

function love.update(dt)
    GlobalUpdate()
    if activeScreen then activeScreen:update(dt) end
end

function love.errorhandler(msg)
    return function()
        print(msg)
        throw.error() -- error, throw is nil
        return 1
    end
end

function love.keypressed(key, scancode, isrepeat)
    if activeScreen then activeScreen:keypressed(key, scancode, isrepeat) end
end

function love.keyreleased(key)
    if activeScreen then activeScreen:keyreleased(key) end
end

function love.draw()
    if activeScreen then activeScreen:draw() end
    if #overlays ~= 0 then
        for _, v in pairs(overlays) do
            if v.draw then v:draw() end
        end
    end
end
