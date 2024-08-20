local note_display = {
	note_nodes = {},
	receptor_nodes = {}
}

function note_display:draw_receptors()
	for _,v in pairs(note_display.receptor_nodes) do
		if v then v:draw() end
	end
end

function note_display:draw_notes()
	for _,v in pairs(note_display.note_nodes) do
		if v then v:draw() end
	end
end

return note_display
