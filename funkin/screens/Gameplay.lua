local Gameplay = require("jigw.Screen"):extend()
function Gameplay:__tostring() return "Gameplay" end

-- Gameplay.NoteDisplay
-- Gameplay.Players
-- Gameplay.Tally
-- idk --


function Gameplay:new()
	Gameplay.super.new()
	return self
end

return Gameplay
