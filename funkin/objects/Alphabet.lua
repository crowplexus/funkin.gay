local Alphabet = Object:extend("Alphabet") --- @class Alphabet
function Alphabet:__tostring() return "Alphabet" end

local X_PER_SPACE = 40
local Y_PER_COLUMN = 20

function Alphabet:new()
  self.characters = {} --- @type table<AnimatedSprite>
  self.text = "" --- @type string
	self.position = Vector2(0, 0)
	self.scale = Vector2(1, 1)
end

--#region Setters
function Alphabet:set_text(vl)
  self._text = vl
	local offsetX = 0
	local offsetY = 0
  local chars = string.split(vl)
	local ASpr = require("jigw.objects.AnimatedSprite")

  for i=1,#chars do
    local char = chars[i]
		if char == " " then
			offsetX = offsetX + X_PER_SPACE
			goto skip
		end

		local letter = ASpr(self.position.x+offsetX, self.position.y+offsetY)

		::skip::
  end
  return vl
end
--#endregion

return Alphabet
