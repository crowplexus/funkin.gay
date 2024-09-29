local Alphabet = Object:extend() --- @class Alphabet
function Alphabet:__tostring() return "Alphabet" end

function Alphabet:new()
  self.characters = {} --- @type table<AnimatedSprite>
  self.text = "" --- @type string
end

--#region Setters
function Alphabet:set_text(vl)
  self._text = vl
  local chars = vl:split()
  for i=1,#chars do
    local char = chars[i]
    print(char)
  end
  return vl
end
--#endregion

return Alphabet