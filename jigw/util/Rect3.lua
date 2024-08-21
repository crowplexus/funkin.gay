local Rect3 = Object:extend()

function Rect3:new(x,y,z,w,h,d)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.width = w or 0
	self.height = h or 0
	self.depth = d or 0
end

function Rect3:round()
	return Rect3:new(
		math.floor(x+0.5), math.floor(y+0.5), math.floor(z+0.5),
		math.floor(width+0.5), math.floor(height+0.5), math.floor(depth+0.5)
	)
end

return Rect3
