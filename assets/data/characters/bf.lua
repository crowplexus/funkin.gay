local Boyfriend = require("funkin.objects.Character"):extend()

function Boyfriend:construct()
	self.super.construct(self)
	self.displayName = "Boyfriend"
	self:loadAtlas(Paths.getPath("play/characters/BOYFRIEND"), {
		{ "idle",  "BF idle dance", 24, false },
		{ "singLEFT",  "BF NOTE LEFT",  24, false, offset = { x = -13, y = 3 } },
		{ "singDOWN",  "BF NOTE DOWN",  24, false, offset = { x = 0, y = 25 } },
		{ "singUP",    "BF NOTE UP",    24, false, offset = { x = 30, y = -15 } },
		{ "singRIGHT", "BF NOTE RIGHT", 24, false, offset = { x = 40, y = 2 } },
	})
	self.singList = { "singLEFT", "singDOWN", "singUP", "singRIGHT" } --- @type table
	self.idleList = { "idle" }                                     --- @type table
	self.singDuration = 4
	self:dance(true)
end

return Boyfriend
