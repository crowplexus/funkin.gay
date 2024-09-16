local Vector3 = Object:extend()

function Vector3:new(x,y,z)
	self.x = (x and type(x) == "number") and x or 0
	self.y = (y and type(y) == "number") and y or 0
	self.z = (z and type(z) == "number") and z or 0
end

function Vector3:round()
	return Vector3:new(math.floor(self.x+0.5),math.floor(self.y+0.5),math.floor(self.z+0.5))
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

function Vector3:unpack()
    return self.x, self.y, self.z
end

function Vector3:__tostring()
	return "X: "..self.x.." Y: "..self.y.." Z: "..self.z
end

return Vector3
