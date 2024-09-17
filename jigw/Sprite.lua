local function buildSprite(sel)
	sel.position = Vector3(0,0,0) -- X, Y, Z
	sel.zAsLayer = true -- treats Z position value as a layer index, is a toggle so you can use Z for something else
	sel.scale = Vector2(1,1)
	sel.color = Color.rgb(255,255,255)
	sel.visible = true
	sel.rotation = 0
	sel.alpha = 1.0
	sel.texture = nil
	return sel
end

local Sprite = Object:extend()

function Sprite:new(x,y,tex)
	buildSprite(self)
	self.position = Vector3(x,y,0)
	if tex then self.texture = tex end
end

function Sprite:dispose()
	self.texture:release()
	buildSprite(self)
end

function Sprite:draw()
	if self and self.texture and self.visible and self.color[4] > 0.0 then
		love.graphics.setColor(self.color)
		love.graphics.draw(self.texture,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		love.graphics.setColor(Color.rgb(1,1,1,1))
	end
end

--#region Getters and Setters
function Sprite:get_alpha() return rawget(self,self.color[4]) end
function Sprite:set_alpha(vl) return rawset(self,self.color[4],vl) end
--#endregion

function Sprite:centerPosition(_x_)
	_x_ = string.lower(_x_)
	local vpw, vph = love.graphics.getDimensions()
	if string.find(_x_,"x") then
		local width = self.texture:getWidth() or 0
		self.position.x = (vpw-width)*0.5
	end
	if string.find(_x_,"y") then
		local height = self.texture:getHeight() or 0
		self.position.y = (vph-height)*0.5
	end
end

function Sprite:screenCenter(_x_)
    return self:centerPosition(_x);
end

return Sprite
