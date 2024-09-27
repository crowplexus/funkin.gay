--- Contains fields to define which direction the bar foreground goes to
--- @enum ProgressFill
ProgressFill = {
  LTR = 0, --- @type number Left to Right
  RTL = 1, --- @type number Right to Left
  TTB = 2, --- @type number Top to Bottom
  BTT = 3, --- @type number Bottom to Top
}

--- Object used for a visual representation of a percentage.
local ProgressBar = Object:extend() --- @class ProgressBar
function ProgressBar:__tostring() return "ProgressBar" end

function ProgressBar:new(x,y,w,h,colors)
  if colors == nil or #colors < 2 then
    colors = {Color.WHITE, Color.BLACK}
  end
  self.position   = Vector2(x,y)                    --- @class Vector2
  self.size       = Vector2(w or 590,h or 10)       --- @class Vector2
  self.colors     = colors                          --- @type table
  self.rotation   = 0                               --- @type number
  self.centered   = false                           --- @type boolean
  self.visible    = true                            --- @type boolean
  self.border     = {width=10,color=Color.BLACK}    --- @type table<number,table>
  self.minPercent = 0                               --- @type number minimum percentage value, by default, set to 0
  self.maxPercent = 100                             --- @type number maximum percentage value, by default, set to 100
  self.percentage = 0                               --- @type number percentage of the progress bar, ranging from 0 to `self.maxValue`
  self.fillMode   = ProgressFill.LTR                --- @type ProgressFill|number used to denominate where the progress color of the bar should go
  return self
end

function ProgressBar:getWidth()
  local more = self.border and self.border.width or 0
  return self.size.x + more
end

function ProgressBar:getHeight() return self.size.y end

function ProgressBar:draw()
  if self.visible == true then
    self:drawBackground()
    self:drawProgress  ()
  end
end

function ProgressBar:drawProgress()
  love.graphics.push()
  love.graphics.setColor(self.colors[2])

  -- TODO: image filling?

  local vertical = self.fillMode == ProgressFill.TTB or self.fillMode == ProgressFill.BTT
  local inReverse = not vertical and self.fillMode == ProgressFill.RTL or self.fillMode == ProgressFill.BTT

  local perRange = self.maxPercent - self.minPercent
  local rangeFrac = (self.percentage - self.minPercent) / perRange
  local dependingSize = not vertical and self:getWidth() or self:getHeight()

  local fillSize = math.round(rangeFrac * dependingSize)
  if inReverse then fillSize = math.round(dependingSize - (rangeFrac * dependingSize)) end

	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
  love.graphics.rectangle("fill",0,0,
        vertical and self:getWidth() or fillSize,
    not vertical and self:getHeight() or fillSize)
  love.graphics.setColor(Color.WHITE)
  love.graphics.pop()
end

function ProgressBar:drawBackground()
  love.graphics.push()
  love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
  if(self.border and self.border.width > 0) then
    love.graphics.setColor(self.border.color or Color.BLACK)
    love.graphics.setLineWidth(self.border.width)
    love.graphics.rectangle("line",0,0,self:getWidth(),self:getHeight())
    love.graphics.setLineWidth(1)
  end
  love.graphics.setColor(self.colors[1])
  love.graphics.rectangle("fill",0,0,self:getWidth(),self:getHeight())
  love.graphics.setColor(Color.WHITE)
  love.graphics.pop()
end

function ProgressBar:centerPosition(_x_)
	if type(_x_) ~= "string" then _x_ = "xy" end
	_x_ = string.lower(_x_)
	local vpw, vph = love.graphics.getDimensions()
	if string.find(_x_, "x") then
		self.position.x = (vpw - self:getWidth()) * 0.5;
	end
	if string.find(_x_, "y") then
		self.position.y = (vph - self:getWidth()) * 0.5;
	end
end

return ProgressBar
