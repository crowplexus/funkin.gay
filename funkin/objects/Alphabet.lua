local Alphabet = Object:extend() --- @class Alphabet
function Alphabet:__tostring() return "Alphabet" end

function Alphabet:new()
  self.characters = {} --- @type table<AnimatedSprite>
  self.text = "" --- @type string
end

function Alphabet:setText(__)
  local v = rawset(self,rawget(self,"text"),__)
  local chars = __:split("")
  for i=1,#chars do
    local char = chars[i]
    print(char)
  end
  return v
end

return Alphabet