local PopupSprite = require("jigw.objects.Sprite"):extend("PopupSprite")

--- @see https://github.com/HaxeFlixel/flixel/blob/f5087ea69e42750893ac4ec29dc4367714ab815b/flixel/math/FlxVelocity.hx#L232
local function computeVelocity(vel, accel, dt)
	local delta = accel <= 0.0 and 0.0 or dt
	return vel + accel * delta
end

function PopupSprite:construct(x, y, tex)
	self.super.construct(self, x, y, tex)
	self.velocity = Vector2(0, 0)
	self.acceleration = Vector2(0, 0)
	self.moving = false
end

function PopupSprite:update(dt)
	if self.super.update then
		self.super:update(dt)
	end
	if self.moving and self.texture then
		self:updateVelocity(dt)
	end
end

function PopupSprite:updateVelocity(dt)
	local velocityDelta = {
		x = 0.5 * (computeVelocity(self.velocity.x, self.acceleration.x, dt) - self.velocity.x),
		y = 0.5 * (computeVelocity(self.velocity.y, self.acceleration.y, dt) - self.velocity.y),
	}

	self.velocity.x = self.velocity.x + velocityDelta.x * 2.0
	self.velocity.y = self.velocity.y + velocityDelta.y * 2.0

	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.y + self.velocity.y * dt

	return velocityDelta
end

return PopupSprite
