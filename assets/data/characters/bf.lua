local Boyfriend = require("funkin.gameplay.Character"):extend()

function Boyfriend:construct()
	self.super.construct(self)
	self.displayName = "Boyfriend"
	self:loadAtlas(Paths.getPath("play/characters/BOYFRIEND"), {
		{ "idle",      "BF idle dance", 24, true,  0,     0 },
		{ "singLEFT",  "BF NOTE LEFT",  24, false, -13,   3 },
		{ "singDOWN",  "BF NOTE DOWN",  24, false, 0,    25 },
		{ "singUP",    "BF NOTE UP",    24, false, 30,  -15 },
		{ "singRIGHT", "BF NOTE RIGHT", 24, false, 40,    2 },
	})
	self.singList = { "singLEFT", "singDOWN", "singUP", "singRIGHT" } --- @type table
	self.idleList = { "idle" }                                     --- @type table
	self.singDuration = 4
	self:dance(true)
end

return Boyfriend
