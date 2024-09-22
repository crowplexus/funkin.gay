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
  local jh = require("funkin.JudgementHolder")
  local judges = jh.getList()
  for i = 1, #judges do str = str .. jh.judgeToPlural(judges[i][1]) .. ": 0\n" end
  return str
end

local function getScoreText(tally)
  if tostring(tally) ~= "Tally" then
    return "Score: N/A | Accuracy: N/A% | N/A"
  end
  return "Score: " .. Utils.thousandSep(tally.score)
      .. " | Accuracy: " .. string.format("%.2f", tally:getAccuracy()) .. "%"
      .. " | (" .. tally.clear .. ") " .. tally:getCurrentGrade()
end

function Gameplay:new()
  Gameplay.super.new()
  buildGameplay(self)
  return Gameplay
end

function Gameplay:enter()
  local Label = require("jigw.objects.Label")
  local ColorShape = require("jigw.objects.ColorShape")
  local tally = require("funkin.data.Tally")()

  local vpw, vph = love.graphics.getDimensions()

  local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
  bg:centerPosition()
  self:add(bg)

  Gameplay.hud.scoreText = Label(0, 0, getScoreText(tally), 20)
  Gameplay.hud.scoreText.position.y = (vph - Gameplay.hud.scoreText.size.y) - 15
  Gameplay.hud.scoreText:centerPosition("sex") -- funny how that works huh.
  Gameplay.hud.scoreText.strokeSize = 1.25
  self:add(Gameplay.hud.scoreText)

  Gameplay.hud.judgementCounter = Label(5, 0, getJudges(), 20)
  Gameplay.hud.judgementCounter.position.y = (vph - Gameplay.hud.judgementCounter.size.y) * 0.5
  Gameplay.hud.judgementCounter.strokeSize = 1.25
  self:add(Gameplay.hud.judgementCounter)

  Gameplay:countdown()
end

function Gameplay:keypressed(key)
  if key == "escape" then
    ScreenManager:switchScreen("funkin.screens.MainMenu")
  end
end

local counter = 1
local path = "assets/images/ui/countdown/"
local sprites = { "prepare", "ready", "set", "go" }
local sounds = { "intro3", "intro2", "intro1", "introGo" }
local Tween = require("libraries.tween")

local tweens = {};

function Gameplay:countdown()
  Timer.create(0.5, function(timer)
    Gameplay:progressCountdown()
    counter = counter + 1
    if counter == 5 then
      local freaky = love.audio.newSource("assets/audio/bgm/freakyMenu.ogg","stream")
      freaky:setLooping(true)
      freaky:setVolume(0.3)
      freaky:play()
    end
  end,0,true)
end

function Gameplay:progressCountdown()
  if counter <= #sounds then
    local audioPath = "assets/audio/sfx/" .. sounds[counter] .. ".ogg"
    if love.filesystem.getInfo(audioPath) ~= nil then
      local countdownSound = love.audio.newSource(audioPath, "static")
      countdownSound:setVolume(0.5)
      countdownSound:play()
      Timer.create(countdownSound:getDuration("seconds"), function() countdownSound:release() end, 0)
    end
  end
  if counter <= #sprites then
    local spritePath = path .. sprites[counter] .. ".png"
    if love.filesystem.getInfo(spritePath) ~= nil then
      local countdownSprite = require("jigw.objects.Sprite")(0, 0, love.graphics.newImage(spritePath))
      countdownSprite:centerPosition("XY")
      self:add(countdownSprite)
      table.insert(tweens, Tween.new(0.8, countdownSprite, { scale = {x = 0, y = 0} }, "inOutCubic"))
      Timer.create(1.5, function() countdownSprite:dispose() end, 0)
    end
  end
end

function Gameplay:update(dt)
  local i = 1;
  while i <= #tweens do
    tweens[i]:update(dt);
    if(tweens[i].clock >= tweens[i].duration)then
      table.remove(tweens, i);
      return;
    end
    i = i + 1;
  end
end

return Gameplay -- does this even do anything at ALL?