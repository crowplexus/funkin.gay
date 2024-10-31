local Character = require("jigw.objects.AnimatedSprite"):extend("Character")
function Character:__tostring()
	return 'Character "' .. tostring(self.displayName) .. '"'
end

--Utils.tablePrint(Character)

function Character:construct(x, y)
	Character.super.construct(self, x, y)
	self.displayName = self.__class --- @type string
	--- Character's sing duration (in seconds)
	--- @type number
	self.singDuration = 4
	self.singList = {} --- @type table
	self.idleList = {} --- @type table
	self._curIdle = 1 --- @type number
end

function Character:dance(force)
	self:playAnimation(self.idleList[self._curIdle], force)
	self._curIdle = Utils.wrap(self._curIdle + 1, 1, #self.idleList)
end

function Character.load(module)
	local mod = require(module)
	mod:construct()
	return mod
end

return Character
