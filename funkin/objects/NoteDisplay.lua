local NoteDisplay = {
	noteObjects = {},
	receptorNotes = {},
	maxColumns = 4,
}

function NoteDisplay:generateNote(kind, column)
	local AnimatedSprite = require("jigw.objects.AnimatedSprite")
	local directions = {"Left","Down","Up","Right"}
	local defaultNote = AnimatedSprite(0,0)
	defaultNote:loadAtlas("assets/images/notes/normal/arrows", {
		{"default", "note"..directions[column], 0}
	})
	defaultNote:playAnimation("default")
	return defaultNote
end

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
