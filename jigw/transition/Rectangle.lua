Transition = Object:extend()

local transIn = true --- @type boolean
local finished = true --- @type boolean
local started = false --- @type boolean

local speed = 50 --- @type number
local rectS = 0 --- @type number
local canvasSize --- @class Vector2

function Transition:reset()
	started = false
	finished = false
	transIn = true
	local w, h = love.graphics.getDimensions()
	canvasSize = Vector2(w,h)
end

function Transition:draw()
	if finished then return end
	local rectX = (canvasSize.x-rectS) * 0.5
  local rectY = (canvasSize.y-rectS) * 0.5
	love.graphics.setColor(Colour.rgb(0,0,0))
  love.graphics.rectangle("fill",rectX,rectY,rectS,rectS)
  love.graphics.setColor(Colour.rgb(255,255,255))
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
