---@diagnostic disable-next-line: undefined-field
local Gameplay = Screen:extend("Gameplay")
local Conductor = nil

function Gameplay:__tostring() return "Gameplay" end

function Gameplay:new()
  Gameplay.super.new()
  return Gameplay
end

function Gameplay:enter()
  local vpw, vph = love.graphics.getDimensions()
  local ColorShape = require("jigw.objects.ColorShape")

	-- make a conductor here for gameplay, bpm is placeholder.
	Conductor = require("funkin.Conductor")(100)

  local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
  bg:centerPosition(Axis.XY)
  self:add(bg)

  self.hud = require("funkin.objects.hud.DefaultHUD")()
  self:add(self.hud)

  Timer.create(0.25, function() self:beginCountdown() end, 0, true)
end

function Gameplay:keypressed(key)
  if key == "escape" then ScreenManager:switchScreen("funkin.screens.MainMenu") end
  if key == "d" then
    self.hud:displayJudgement("sick")
    self.hud:displayCombo(math.random(0,1000000))
  end
end

local counter = 1
local sprites = { "prepare", "ready", "set", "go" }
local sounds = { "intro3", "intro2", "intro1", "introGo" }

function Gameplay:beginCountdown()
  Timer.create(Conductor.crotchet, function()
    Gameplay:progressCountdown()
    counter = counter + 1
  end,#sprites,true)
end

function Gameplay:progressCountdown()
  if counter <= #sounds then
    local audioPath = "assets/play/countdown/sfx/" .. sounds[counter] .. ".ogg"
    if love.filesystem.getInfo(audioPath) ~= nil then
      local countdownSound = love.audio.newSource(audioPath, "static")
      countdownSound:setVolume(0.5)
      countdownSound:play()
      Timer.create(countdownSound:getDuration("seconds"), function() countdownSound:release() end, 0)
    end
  end
  if counter <= #sprites then
		local path = "assets/play/countdown/"
    local spritePath = path .. sprites[counter] .. ".png"
    if love.filesystem.getInfo(spritePath) ~= nil then
      local countdownSprite = require("jigw.objects.Sprite")(0, 0, love.graphics.newImage(spritePath))
      countdownSprite:centerPosition(Axis.XY)
			local yy = countdownSprite.position.y
			self:add(countdownSprite)

			local ctime = Conductor.crotchet
      Timer.create(ctime + 0.001, function() countdownSprite:dispose() end)
      Tween.create(0.5, countdownSprite.position, { y = yy - 50 }, "inBack")
      Tween.create(ctime, countdownSprite, { alpha = 0.0 }, "inOutCubic")
    end
  end
end

return Gameplay -- does this even do anything at ALL?
