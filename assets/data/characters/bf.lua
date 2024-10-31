local Boyfriend = require("funkin.objects.Character"):extend()

function Boyfriend:construct()
	self.super.construct(self)
	self.displayName = "Boyfriend"

	self:loadAtlas(Paths.getPath("play/characters/BOYFRIEND"), {
		{ "idle", "BF idle dance", 24, false },
	})

	self.singList = { "singLEFT", "singDOWN", "singUP", "singRIGHT" } --- @type table
	self.idleList = { "idle" } --- @type table
	self.singDuration = 4

	self:dance(true)
	print("byofirned loaded")
end

return Boyfriend
