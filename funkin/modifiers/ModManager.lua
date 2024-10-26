--- @enum NoteScrollType
NoteScrollType = {
	UP 			= 1,
	CENTER	= 3,
	DOWN		= 2,
}
local ModManager = Object:extend("ModManager") --- @class ModManager
--- @param scroll number|NoteScrollType Type of scroll.
---@param field NoteDisplay ID of the notefield to change scroll of.
function ModManager:changeScroll(scroll, field)
end
return ModManager