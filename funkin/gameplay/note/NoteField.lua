--- A field with 4 (or so) notes, usually displayed at the top of the screen
--- @class NoteField
local NoteField = Classic:extend("NoteField")

local AnimatedSprite = require("jigw.objects.AnimatedSprite")

local _receptors = {}

--- Constructs a new NoteField.
---
--- @param x number			X coordinate to draw the notefield to.
--- @param y number			Y coordinate to draw the notefield to.
--- @param totalColumns number Number of receptors in the notefield.
function NoteField:construct(x, y, totalColumns)
	self.totalColumns = totalColumns or 4
	self.position = Vector2(x, y)
	self.scale = Vector2(0.8, 0.8)
	self.color = Color.WHITE()
	self.visible = true
	self.rotation = 0
	self.alpha = 1.0
	for i = 1, self.totalColumns do
		local offset = (200 * self.scale.x) * i
		self:addReceptor(offset, 0, i)
	end
end

function NoteField:update(dt)
	for i = 1, #_receptors do
		local receptor = _receptors[i]
		if receptor and receptor.update then receptor:update(dt) end
	end
end

function NoteField:draw()
	for i = 1, #_receptors do
		local receptor = _receptors[i]
		if receptor and receptor.draw then
			love.graphics.push("all")
			love.graphics.setColor(self.color)
			love.graphics.translate(self.position:unpack())
			love.graphics.rotate(self.rotation)
			love.graphics.scale(self.scale.x, self.scale.y)
			receptor:draw()
			--love.graphics.setColor(Color.WHITE())
			love.graphics.pop()
		end
	end
end

--- Plays an animation on a receptor.
--- @param column number The column of the receptor to play the animation on.
--- @param animation string The name of the animation to play.
--- @param force boolean Whether to force the animation to play from the benning.
function NoteField:playAnimation(column, animation, force)
	column = math.abs(column)
	force = force or false
	_receptors[column]:playAnimation(animation, force)
	--print("played "..animation.." on "..column)
end

function NoteField:addReceptor(x, y, column, atlas)
	atlas = atlas or Paths.getPath("play/notes/normal/notes")
	local receptor = AnimatedSprite(x, y)
	local dirs = { "left", "down", "up", "right" }
	local dir = tostring(dirs[column > 4 and column % #dirs or column])
	receptor:loadAtlas(atlas, {
		{ "static",  "arrow" .. string.upper(dir),    0 },
		{ "press",   string.lower(dir) .. " press",   24 },
		{ "confirm", string.lower(dir) .. " confirm", 24 }
	})
	receptor:playAnimation("static", true)
	_receptors[column] = receptor
	return receptor
end

function NoteField:removeReceptor(column)
	if table[id] ~= nil then
		table.remove(self.receptors, column)
	end
end

return NoteField
