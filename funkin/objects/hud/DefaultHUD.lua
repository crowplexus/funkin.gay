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

	self.scoreText = nil --- @type jigw.objects.Label
	self.judgementCounter = nil --- @type jigw.objects.Label

	local Label = require("jigw.objects.Label")
  local vpw, vph = love.graphics.getDimensions()

	self.scoreText = Label(0, 0, getScoreText(), 20)
  self.scoreText.position.y = (vph - self.scoreText.size.y) - 15
  self.scoreText:centerPosition("sex") -- funny how that works huh.
  self.scoreText.strokeSize = 1.25
  --self:add(self.scoreText)

  self.judgementCounter = Label(5, 0, getJudges(), 20)
  self.judgementCounter.position.y = (vph - self.judgementCounter.size.y) * 0.5
  self.judgementCounter.strokeSize = 1.25
  --self:add(self.judgementCounter)

  --[[ -- TODO
  local downscroll = false
  local hpb = downscroll and vpw * 0.175 or vpw * 0.875

  self.healthBar = ProgressBar(0,hbp)
  self.healthBar.fillDirection = ProgressFill.RTL -- LTR, RTL, BTT, TTB?
  self.healthBar.colors = { Color.rgb(255,0,0), Color.rgb(102,255,51) }
  self.healthBar.value = 50 -- center the primary rectangle in the bar
  self.healthBar.centerPosition("X")]]
end

function DefaultHUD:draw()
	-- TODO: better way to draw here??? idk
	if self.scoreText and self.scoreText.draw then
		self.scoreText:draw()
	end
	if self.judgementCounter and self.judgementCounter.draw then
		self.judgementCounter:draw() -- TODO: better counter
	end
	--[[if self.healthBar and self.healthBar.draw then
		self.healthBar:draw()
	end]]
end

return DefaultHUD
