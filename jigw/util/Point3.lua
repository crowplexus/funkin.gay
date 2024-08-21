local Point3 = Object:extend()
function Point3:new(x,y,z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or z
end
function Point3:round()
	return Point3:new(math.floor(x+0.5),math.floor(y+0.5),math.floor(z+0.5))
end
return Point3
