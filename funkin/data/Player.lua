local Player = {}

function Player.create(autoplay, notefield)
	local self = {}
	self.autoplay = autoplay or true
	return self
end

function Player.handleInput(self, notes)
	local sorted = nil
end

function Player.handleRelease(self)
end

return Player