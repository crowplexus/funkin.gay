---@diagnostic disable-next-line: undefined-field
local Gameplay = require("jigw.Screen"):extend()
function Gameplay:__tostring() return "Gameplay" end
local function buildGameplay(sel) -- I really need a better system for this :p -star
	sel.hud = {
		scoreText = nil,
		judgementCounter = nil,
	}
	return sel
end

local function getJudges()
  local str = ""
  local judges = {"Epics","Sicks","Goods","Bads","Shits","Misses"}
  local counts = {0,      0,      0,      0,      0,      0}
  for i=1,#judges do str = str..judges[i]..": "..counts[i].."\n" end
  return str
end

local function getScoreText(tally)
  if tostring(tally) ~= "Tally" then
    return "Score: N/A | Accuracy: N/A% | N/A"
  end
	return "Score: "..Utils.thousandSep(tally.score)
        .." | Accuracy: "..string.format("%.2f", tally:getAccuracy()).."%"
        .." | ("..tally.clear..") "..tally:getCurrentGrade()
end

function Gameplay:new()
	Gameplay.super.new()
	buildGameplay(self)

	local Label = require("jigw.objects.Label")
	local ColorShape = require("jigw.objects.ColorShape")
  local tally = require("funkin.data.Tally")()

	local vpw, vph = love.graphics.getDimensions()

  local bg = ColorShape(0,0,Color.rgb(80,80,80),vpw,vph)
  bg:centerPosition()
  self:add(bg)

  Gameplay.hud.scoreText = Label(0,0,getScoreText(tally),20)
  Gameplay.hud.scoreText.position.y = (vph - Gameplay.hud.scoreText.size.y) - 15
  Gameplay.hud.scoreText:centerPosition("sex") -- funny how that works huh.
  Gameplay.hud.scoreText.strokeSize = 1.25
  self:add(Gameplay.hud.scoreText)

  Gameplay.hud.judgementCounter = Label(5,0,getJudges(),20)
  Gameplay.hud.judgementCounter.position.y = (vph-Gameplay.hud.judgementCounter.size.y)*0.5
  Gameplay.hud.judgementCounter.strokeSize = 2
  self:add(Gameplay.hud.judgementCounter)

	return Gameplay
end

function Gameplay:keypressed(key)
	if key == "escape" then
    ScreenManager:switchScreen("funkin.screens.MainMenu")
  end
end

return Gameplay -- does this even do anything at ALL?
