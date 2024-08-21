local Point2 = Object:extend()

function Point2:new(x,y)
	self.x = x or 0
	self.y = y or 0
end

function Point2:round()
	return Point2:new(math.floor(x+0.5),math.floor(y+0.5))
end

return Point2
