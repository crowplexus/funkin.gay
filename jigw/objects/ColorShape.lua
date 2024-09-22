--- @enum ShapeType
ShapeType = {
  RECTANGLE = 1,
  CIRCLE    = 2,
}

local ColorShape = Object:extend() --- @class ColorShape
local function buildColorShape(sel)
  sel.position = Vector2(0,0)
  sel.size = Vector2(0,0)
  sel.color = Color.WHITE
  sel.shape = ShapeType.RECTANGLE
  sel.visible = true
  sel.centered = false
  sel.rotation = 0
  return sel
end

function ColorShape:new(x,y,c,sx,sy)
  buildColorShape(ColorShape)
  if type(c) ~= "table" then c = Color.WHITE end
  self.position = Vector2(x,y)
  self.size = Vector2(sx or 50,sy or 50)
  self.color = c
  return self
end

function ColorShape:draw()
  if self and self.visible and self.color[4] > 0.0 then
    love.graphics.setColor(self.color)
    love.graphics.push()
    Utils.match(self.shape, {
      [1] = function()
        local frW, frH = self.size:unpack()
        love.graphics.translate(self.position:unpack())
        love.graphics.rotate(self.rotation)
        if(self.centered)then
          love.graphics.translate(-frW * 0.5, -frH * 0.5)
        end
        love.graphics.rectangle("fill",0,0,self.size.x,self.size.y)
      end,
      [2] = function()
        local frW, frH = self.size:unpack()
        love.graphics.translate(self.position:unpack())
        love.graphics.rotate(self.rotation)
        --if(self.centered)then
        --  love.graphics.translate(-frW * 0.5, -frH * 0.5)
        --end
        love.graphics.circle("fill",0,0,-self.size.x,self.size.y)
      end,
    })
    love.graphics.pop()
    love.graphics.setColor(Color.WHITE)
  end
end

function ColorShape:centerPosition(_x_)
  if type(_x_) ~= "string" then _x_ = "xy" end
	_x_ = string.lower(_x_)
	local vpw, vph = love.graphics.getDimensions()
  self.centered = true;
	if string.find(_x_,"x") then
		self.position.x = vpw * 0.5;
	end
	if string.find(_x_,"y") then
		self.position.y = vph * 0.5;
	end
end

return ColorShape