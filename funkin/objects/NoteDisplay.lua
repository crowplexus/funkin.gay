local NoteDisplay = {
	noteObjects = {},
	receptorNotes = {},
	maxColumns = 4,
}

--- @enum NoteParts
local NoteParts = {
	TapBody = 0,
	HoldBody = 1,
	HoldTail = 2,
	--[[TODO:
		maybe include RollBody and RollTail just so you can draw them differently
		maybe include TapStroke for custom outlines for noteskins
		maybe include MineBody for custom note kinds (i.e: Mines/Hurt Notes)
	]]
}

function NoteDisplay:drawReceptors()
	for i=1, #self.receptorNotes do
		local v = self.receptorNotes[i]
		if v and v.draw then v:draw() end
	end
end

function NoteDisplay:drawNotes()
	for i=1, #self.noteObjects do
		local v = self.noteObjects[i]
		if v and v.draw then v:draw() end
	end
end

return NoteDisplay
