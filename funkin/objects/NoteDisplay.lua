local noteDisplay = {
	noteObjects = {},
	receptorNotes = {}
}

function noteDisplay:drawReceptors()
	for _,v in pairs(noteDisplay.receptorNotes) do
		if v then v:draw() end
	end
end

function noteDisplay:drawNotes()
	for _,v in pairs(noteDisplay.noteObjects) do
		if v then v:draw() end
	end
end

return noteDisplay
