---@diagnostic disable: duplicate-set-field

local main_menu = require("jigw.screen")
main_menu:clone() -- extend screen, borrow its functions.
main_menu.__name = "Main Menu" -- for debugging.

local tex

function main_menu:enter()
  tex = love.graphics.newImage("assets/car.jpg")
  local freaky = love.audio.newSource("assets/music/freakyMenu.ogg","stream")
  freaky:setVolume(0.1)
  freaky:play()
end

function main_menu:draw()
  if tex ~= nil then
    love.graphics.draw(tex,0,0,0,1.4,1.0)
  end
end

return main_menu