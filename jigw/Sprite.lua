local function buildSprite(sel)
	sel.position = Point2(0,0)
	sel.scale = Point2(1,1)
	sel.colour = Colour.rgba(1,1,1,1)
	sel.visible = true
	sel.rotation = 0
	sel.alpha = 1.0
	sel.texture = nil
	return sel
end

local Sprite = Object:extend()
buildSprite(Sprite)

function Sprite:new(x,y,tex)
	self.position = Point2(x,y)
	if tex then self.texture = tex end
	return self
end

function Sprite:dispose()
	self.texture:release()
	resetVars()
end

function Sprite:draw()
	if self and self.texture and self.visible and self.colour[4] > 0.0 then
		love.graphics.setColor(self.colour)
		love.graphics.draw(self.texture,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		love.graphics.setColor(Colour.rgba(1,1,1,1))
	end
end

--#region Getters and Setters
function Sprite:get_alpha() return rawget(self,self.colour[4]) end
function Sprite:set_alpha(vl) return rawset(self,self.colour[4],vl) end
--#endregion

function Sprite:__index(idx)
  -- custom get variable functionality
  return rawget(self,"get_"..idx) and rawget(self,"get_"..idx)() or rawget(self,idx)
end

function Sprite:__newindex(idx,vl)
  -- custom set variable functionality
  return rawget(self,"set_"..idx) and rawget(self,"set_"..idx)(self,vl) or rawset(self,idx,vl)
end

return Sprite
