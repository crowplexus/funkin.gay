--- @enum NoteScrollType
NoteScrollType = { UP = 1, CENTER = 3, DOWN = 2 }

local Modchart = Classic:extend("Modchart") --- @class Modchart

--- @param scroll number|NoteScrollType Type of scroll.
---@param field NoteDisplay ID of the notefield to change scroll of.
function Modchart:changeScroll(scroll, field) end

return Modchart
