local DefaultHUD = Object:extend()
local judgeHolder = require("funkin.JudgementHolder")

local function getScoreText(tally)
  if not tally or tostring(tally) ~= "Tally" then
    return "Score: N/A | Accuracy: N/A% | N/A"
  end
  return "Score: " .. Utils.thousandSep(tally.score)
      .. " | Accuracy: " .. string.format("%.2f", tally:getAccuracy()) .. "%"
      .. " | (" .. tally.clear .. ") " .. tally:getCurrentGrade()
end

local function getJudges()
  local str = ""
  local judges = judgeHolder.getList()
  for i = 1, #judges do
  	str = str .. judgeHolder.judgeToPlural(judges[i][1]) .. ": 0\n"
  end
  return str
end

function DefaultHUD:new()
	DefaultHUD.super.new()

	self.scoreText = nil --- @class jigw.objects.Label
	self.judgementCounter = nil --- @class jigw.objects.Label

	local Label = require("jigw.objects.Label")
  local ProgressBar = require("jigw.objects.ProgressBar")
  local vpw, vph = love.graphics.getDimensions()

  local downscroll = true
  local healthBarY = downscroll and vpw * 0.05 or vpw * 0.5

  self.healthBar = ProgressBar(0,healthBarY,590,10)
  self.healthBar.colors = { Color.rgb(255,0,0), Color.rgb(102,255,51) }
  self.healthBar.percentage = 50 -- center the primary rectangle in the bar
  self.healthBar.fillMode = ProgressFill.RTL -- LTR, RTL, BTT, TTB
  self.healthBar:centerPosition("x")

	self.scoreText = Label(0, (healthBarY + self.healthBar:getHeight()) + 20, getScoreText(), 20)
  --self.scoreText.position.y = (vph - self.scoreText.size.y) - 15
  self.scoreText:centerPosition("x") -- funny how that works huh.
  self.scoreText.strokeSize = 1.25

  self.judgementCounter = Label(5, 0, getJudges(), 20)
  self.judgementCounter.position.y = (vph - self.judgementCounter.size.y) * 0.5
  self.judgementCounter.strokeSize = 1.25

  --self:add(self.healthBar)
  --self:add(self.scoreText)
  --self:add(self.judgementCounter)
end

local health = 50
local shit = false

function DefaultHUD:draw()
	-- TODO: better way to draw here??? idk
	if self.healthBar and self.healthBar.draw then self.healthBar:draw() end
	if self.scoreText and self.scoreText.draw then self.scoreText:draw() end
	if self.judgementCounter and self.judgementCounter.draw then self.judgementCounter:draw() end
  if shit == false then
    health = health + 0.5
    if health > 100 then shit = true end
  end
  if shit == true then
    health = health - 0.5
    if health < 1 then shit = false end
  end
  self.healthBar.percentage = health
  --print(shit and "pong" or "ping")
end

return DefaultHUD
