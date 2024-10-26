local PopupSprite = require("jigw.objects.Sprite"):extend("PopupSprite")

--- @see https://github.com/HaxeFlixel/flixel/blob/f5087ea69e42750893ac4ec29dc4367714ab815b/flixel/math/FlxVelocity.hx#L232
local function computeVelocity(vel,accel,dt)
  local delta = accel <= 0.0 and 0.0 or dt
  return vel + accel * delta
end

function PopupSprite:new(x,y,tex)
	self.position = Vector2(x,y) -- X, Y
	self.scale = Vector2(1,1)
	self.color = Color.WHITE()
	self.visible = true
	self.centered = false;
	self.texture = tex or nil
	self.rotation = 0
	self.alpha = 1.0

  self.velocity = Vector2(0,0)
  self.acceleration = Vector2(0,0)
  self.moving = false
end

function PopupSprite:update(dt)
  if self.super.update then self.super.update(dt) end
  if self.moving then self:updateVelocity(dt) end
end

function PopupSprite:updateVelocity(dt)
  local velocityDelta = {
    x = 0.5 * (computeVelocity(self.velocity.x, self.acceleration.x, dt) -self.velocity.x),
    y = 0.5 * (computeVelocity(self.velocity.y, self.acceleration.y, dt) -self.velocity.y)
  }

  self.velocity.x = self.velocity.x + velocityDelta.x * 2.0
  self.velocity.y = self.velocity.y + velocityDelta.y * 2.0

  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  return velocityDelta
end

--#region Getters and Setters
function PopupSprite:get_alpha()
	return self.color[4]
end
function PopupSprite:set_alpha(vl)
	if self.color then self.color[4] = vl end
end
--#endregion

return PopupSprite