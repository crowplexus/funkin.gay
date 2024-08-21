local Rect2 = Object:extend()

function Rect2:new(x,y,w,h)
	self.x = x or 0
	self.y = y or 0
	self.width = w or 0
	self.height = h or 0
end

function Rect2:round()
	return Rect2:new(
		math.floor(x+0.5),math.floor(y+0.5),
		math.floor(width+0.5),math.floor(height+0.5)
	)
end

return Rect2
