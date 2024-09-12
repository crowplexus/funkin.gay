local Vector2 = Object:extend()

function Vector2:new(x,y)
	self.x = (x and type(x) == "number") and x or 0
	self.y = (y and type(y) == "number") and y or 0
end

function Vector2:round()
	return Vector2:new(math.floor(x+0.5),math.floor(y+0.5))
end

function Vector2:sortByY(o,a,b)
	if not a or not b then return 0 end
	if not Vector2.is(a) or not Vector2.is(b) then return 0 end
	return a.y < b.y and o or a.y > b.y and -o or 0
end

function Vector2:__tostring()
	return "X: "..self.x.." Y: "..self.y
end

return Vector2
