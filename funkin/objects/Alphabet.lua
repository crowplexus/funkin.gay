local Alphabet = Object:extend() --- @class Alphabet
function Alphabet:__tostring() return "Alphabet" end
local function buildAlphabet(sel)
  sel.characters = {} --- @type table<AnimatedSprite>
  sel.text = "" --- @type string
  return sel
end

function Alphabet:new()
  buildAlphabet(self)
  return self
end

function Alphabet:set_text(__)
  local v = rawset(self,rawget(self,"text"),__)
  -- regenGlyphs()
  return v
end

return Alphabet