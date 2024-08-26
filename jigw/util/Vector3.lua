local Vector3 = Object:extend()

function Vector3:new(x,y,z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function Vector3:round()
	return Vector3:new(math.floor(x+0.5),math.floor(y+0.5),math.floor(z+0.5))
end

function Vector3:sortByY(o,a,b)
	if not a or not b then return 0 end
	if not Vector3.is(a) or not Vector3.is(b) then return 0 end
	return a.y < b.y and o or a.y > b.y and -o or 0
end

function Vector3:sortByZ(o,a,b)
	if not a or not b then return 0 end
	if not Vector3.is(a) or not Vector3.is(b) then return 0 end
	return a.z < b.z and o or a.z > b.z and -o or 0
end

function Vector3:__tostring()
	return "X: "..self.x.." Y: "..self.y.." Z: "..self.z
end

return Vector3
