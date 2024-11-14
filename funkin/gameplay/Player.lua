--- Class representing a player, handles input.
--- @class funkin.gameplay.Player
local Player = Classic:extend("Player")

function Player:_tostring()
	return "Player"
end

--- Initialises a new player.
---
--- @param autoplay boolean							IF the player controls itself.
--- @param notefield funkin.gameplay.note.NoteField Notefield to control.
function Player:construct(autoplay, notefield)
	self.autoplay = autoplay or true
	self.notefield = notefield or false
	self.controls = { "noteL", "noteD", "noteU", "noteR" }
end

--- Static function that handles player input press.
---
--- @param self			funkin.gameplay.Player Instance of a player.
--- @param action		string Action to handle.
--- @param notes?		table Table of notes.
function Player.handleInput(self, action, notes)
	if self.autoplay or self.controls[action] == nil then
		return
	end
	local sorted = nil
end

--- Static function that handles player input release.
---
--- @param self			funkin.gameplay.Player Instance of a player.
--- @param action		string Action to handle.
function Player.handleRelease(self, action)
end

return Player
