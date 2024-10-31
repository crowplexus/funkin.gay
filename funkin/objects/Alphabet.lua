local Alphabet = Classic:extend("Alphabet") --- @class Alphabet

local X_PER_SPACE = 40
local Y_PER_COLUMN = 20

function Alphabet:construct()
	self.characters = {} --- @type table<AnimatedSprite>
	self.text = "" --- @type string
	self.position = Vector2(0, 0)
	self.scale = Vector2(1, 1)
end

function Alphabet:set_text(vl)
	rawset(self, "text", vl)
	local offsetX = 0
	local offsetY = 0
	local chars = string.split(vl)
	local ASpr = require("jigw.objects.AnimatedSprite")

	for i = 1, #chars do
		local char = chars[i]
		if char == " " then
			offsetX = offsetX + X_PER_SPACE
			goto skip
		end

		local letter = ASpr(self.position.x + offsetX, self.position.y + offsetY)
		table.insert(self.characters, #self.characters, letter)
		::skip::
	end
	return vl
end

function Alphabet:draw()
	for i = 1, #self.characters do
		self.characters[i]:draw()
	end
end

return Alphabet
