local NoteDisplay = {
	noteObjects = {},
	receptorNotes = {},
	maxColumns = 4,
}

function NoteDisplay.generateNote(kind, column)
	if type(column) ~= "number" then
		column = 1
	end
	if column == 0 then
		column = column + 1
	end

	local AnimatedSprite = require("jigw.objects.AnimatedSprite")
	local directions = { "left", "down", "up", "right" }
	local colours = { "purple", "blue", "green", "red" }

	local defaultNote = AnimatedSprite(0, 0)
	defaultNote:loadAtlas(Paths.getPath("play/notes/normal/notes"), {
		{ "tap", colours[column], 0 },
	})
	defaultNote:playAnimation("tap", true)
	return defaultNote
end

function NoteDisplay:drawReceptors()
	for i = 1, #self.receptorNotes do
		local v = self.receptorNotes[i]
		if v and v.draw then
			v:draw()
		end
	end
end

function NoteDisplay:drawNotes()
	for i = 1, #self.noteObjects do
		local v = self.noteObjects[i]
		if v and v.draw then
			v:draw()
		end
	end
end

return NoteDisplay
