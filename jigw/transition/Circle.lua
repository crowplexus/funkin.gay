Transition = Object:extend()

local transIn = true --- @type boolean
local finished = true --- @type boolean
local started = false --- @type boolean

local speed = 50 --- @type number
local circS = 0 --- @type number
local canvasSize --- @class Point2

function Transition:reset()
	started = false
	finished = false
	transIn = true
	local w = 1280; local h = 720
	canvasSize = Point2(w,h)
end

function Transition:draw()
	if finished then return end
	local circX = (canvasSize.x) * 0.5
  local circY = (canvasSize.y) * 0.5
	love.graphics.setColor(Colour.rgba(0,0,0,1))
  love.graphics.circle("fill",circX,circY,circS,circS)
  love.graphics.setColor(Colour.rgba(1,1,1,1))
  if transIn then self:inwards() else self:outwards() end
  if circS < 0 then finished = true end
end

function Transition:inwards(force)
  if circS >= 900 then transIn = false end
	if force == true and not started then
		self:reset()
		transIn = true
		started = true
		circS = 0
	end
  circS = circS + speed
end

function Transition:outwards(force)
	if force == true and not started then
		self:reset()
		transIn = false
		started = true
		circS = 900
	end
  circS = circS - speed
end

return Transition
