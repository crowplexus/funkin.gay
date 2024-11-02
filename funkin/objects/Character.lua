local Character = require("jigw.objects.AnimatedSprite"):extend("Character")
function Character:__tostring()
	return 'Character "' .. tostring(self.displayName) .. '"'
end

local _curIdle = 1 --- @type number
local _idleTimer = 0.0 --- @type number

function Character:construct(x, y)
	Character.super.construct(self, x, y)
	self.displayName = self.__class --- @type string
	self.idleList = {} --- @type table
	self.singList = {} --- @type table
	--- Character's sing duration (in seconds)
	--- @type number
	self.singDuration = 4
end

function Character:update(dt)
	Character.super.update(self, dt)
	if not self:isDancing() then
		_idleTimer = _idleTimer - dt * (self.singDuration * (Conductor.getActive().semiquaver * 0.25))
		if _idleTimer <= 0.0 then
			self:dance(true)
		end
		--print("idle timer is "..tostring(_idleTimer))
	end
end

function Character:isDancing()
	local idleName = self.idleList[_curIdle]
	return self:hasAnimation(idleName) and self:getCurrentAnimationName() == idleName
end

function Character:dance(force, suffix)
	suffix = suffix or ""
	self:playAnimation(self.idleList[_curIdle]..suffix, force)
	_curIdle = Utils.wrap(_curIdle + 1, 1, #self.idleList)
end

function Character:sing(dir, force, suffix)
	suffix = suffix or ""
	self:playAnimation(self.singList[dir]..suffix, force)
	_idleTimer = 0.5 * Conductor.getActive().semiquaver
end

function Character.load(module,x,y)
	module = module or ""
	if #module == 0 then
		print("Error loading Character, module name is empty, loading empty character.")
		return Character(x,y)
	end
	local mod = require(module)(x,y)
	if mod == nil then
		print("Error loading character, file \""..module..".lua\" does not exist, loading empty character.")
		return Character(x,y)
	end
	return mod
end

return Character
