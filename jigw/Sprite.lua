local function resetVars(Spr)
	return {
		position = {x = 0, y = 0},
		scale = {x = 1, y = 1},
		color = {1,1,1,1},
		visible = true,
		rotation = 0,
		--alpha = 1.0,
		texture = nil,
	}
end

local Sprite = resetVars()
Sprite.__index = Sprite

function Sprite:new(x,y,tex)
	local self = setmetatable(Sprite, {})
	self.position.x = x or 0
	self.position.y = y or 0
	if tex then self.texture = tex end
	return self
end

function Sprite:dispose()
	self.texture:release()
	resetVars()
end

function Sprite:draw()
	if self and self.texture and self.visible and self.color[4] > 0.0 then
		love.graphics.setColor(self.color)
		love.graphics.draw(self.texture,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		love.graphics.setColor({1,1,1,1})
	end
end

--#region Getters and Setters
function Sprite:get_alpha() return rawget(self,self.color[4]) end
function Sprite:set_alpha(vl) return rawset(self,self.color[4],vl) end
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
