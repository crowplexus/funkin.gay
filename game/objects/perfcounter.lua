--- PerfCounter is a simple object that displays the current FPS on the screen.
--- @class PerfCounter
local PerfCounter, super = Class("PerfCounter", Canvas)

local font = love.graphics.newFont("res/ui/fonts/vcr.ttf", 16, "none")

function PerfCounter:init(x, y)
    super.init(self)
    -- mini vec2
    self.position = {x = x, y = y}
    self.position.unpack = function(addx, addy)
        return self.position.x + (addx or 0), self.position.y + (addy or 0)
    end
end

function PerfCounter:draw()
    love.graphics.push("all")
    local fpsText = love.timer.getFPS() .. " FPS"
    love.graphics.setColor(0, 0, 0, 0.35)
    love.graphics.setFont(font)
    local lbCount = string.len(fpsText) - string.len(fpsText:gsub("\n", ""))
    local fpsWidth = love.graphics.getFont():getWidth(fpsText)
    love.graphics.rectangle("fill", 3, 3, fpsWidth + 5, (lbCount + 1) * 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(fpsText, self.position.unpack())
    love.graphics.pop()
end

return PerfCounter
