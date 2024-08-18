local gameplay = require("jigw.screen"):clone()
gameplay.__name = "Gameplay"

local tex = love.graphics.newImage("assets/car.jpg")

function gameplay:draw()
  love.graphics.rectangle("fill",100,100,50,50)
  love.graphics.draw(tex, tex:getWidth()/2,tex:getHeight()/8,0,0.5,0.5)
end
