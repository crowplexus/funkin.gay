Transition = Object:extend()

local transIn = true --- @type boolean
local finished = true --- @type boolean
local started = false --- @type boolean

local speed = 50 --- @type number
local rectS = 0 --- @type number
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
	local rectX = (canvasSize.x-rectS) * 0.5
  local rectY = (canvasSize.y-rectS) * 0.5
	love.graphics.setColor(Colour.rgba(0,0,0,1))
  love.graphics.rectangle("fill",rectX,rectY,rectS,rectS)
  love.graphics.setColor(Colour.rgba(1,1,1,1))
  if transIn then self:inwards() else self:outwards() end
  if rectS < 0 then finished = true end
end

function Transition:inwards(force)
  if rectS >= 900 then transIn = false end
	if force == true and not started then
		self:reset()
		transIn = true
		started = true
		rectS = 0
	end
  rectS = rectS + speed
end

function Transition:outwards(force)
	if force == true and not started then
		self:reset()
		transIn = false
		started = true
		rectS = 900
	end
  rectS = rectS - speed
end

return Transition
