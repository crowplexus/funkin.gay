local NoteField = Classic:extend("NoteField")

local _receptors = {}

function NoteField:construct(x, y)
	self.position = Vector2(x, y)
	self.scale = Vector2(1, 1)
	self.color = Color.WHITE()
	self.visible = true
	self.rotation = 0
	self.alpha = 1.0
	self.texture = nil
end

function NoteField:draw()
	for i = 1, #_receptors do
		local receptor = _receptors[i]
		if receptor and receptor.draw then receptor:draw() end
	end
end

function NoteField:update(dt)
	for i = 1, #_receptors do
		local receptor = _receptors[i]
		if receptor and receptor.update then receptor:update(dt) end
	end
end

function NoteField:addReceptor(x, y, column, atlas)
	atlas = atlas or Paths.getPath("play/notes/normal/notes")
	local receptor = AnimatedSprite(x, y)
	local dirs = { "left", "down", "up", "right" }
	receptor:addAtlas(atlas, {
		{ "static",  "arrow" .. string.upper(dirs[column]),    0 },
		{ "press",   string.lower(dirs[column]) .. " press",   24 },
		{ "confirm", string.lower(dirs[column]) .. " confirm", 24 }
	})
	receptor:playAnimation("static", true)
	table.insert(_receptors, receptor)
	return receptor
end

function NoteField:removeReceptor(column)
	if table[id] ~= nil then
		table.remove(self.receptors, column)
	end
end

return NoteField
