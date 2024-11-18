local NoteObject = Classic:extend("NoteObject") -- extend AnimatedSprite??

function NoteObject.getColor(column)
	local colors = {"purple", "blue", "green", "red"}
	return colors[column or 1]
end

function NoteObject.getDirection(column)
	local directions = {"left", "down", "up", "right"}
	return directions[column or 1]
end

function NoteObject:construct()
	self.position  = Vector2(0, -5000) --- @type jigw.util.Vector2
	self.scale     = Vector2(1, 1)  --- @class jigw.util.Vector2
	self.color     = Color.WHITE()  --- @type table
	self.visible   = true           --- @type boolean
	self.rotation  = 0              --- @type number
	self.alpha     = 1.0            --- @type number
	self.texture   = nil            --- @class love.graphics.Image

	-- note properties
	self.time      = 0 --- @type number
	self.column    = 0 --- @type number
	self.kind      = "" --- @type string
	self.hold      = {} --- @type table
	self.judgement = nil --- @type table
	self.wasHit    = false --- @type boolean
end

function NoteObject.canBeHit(note)
	-- changing this later btw, probably idk
	-- i really REAAAALLY want to use rows
	local cTime = Conductor.getCurrent().time
	local maxHitWindow = 180.0
	local inRange = (note.time - cTime) < maxHitWindow
	return note and note.judgement == nil and note.wasHit == false and inRange
end

return NoteObject
