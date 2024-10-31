---@diagnostic disable-next-line: undefined-field
local Gameplay = Screen:extend("Gameplay")
local Conductor = nil
local player = nil

function Gameplay:enter()
	local vpw, vph = love.graphics.getDimensions()
	local ColorShape = require("jigw.objects.ColorShape")
	local ChartLoader = require("funkin.data.ChartLoader")
	local chart = ChartLoader:readLegacy("2hot", "hard")
	print("notes caught in the fire: " .. #chart.notes)

	-- make a conductor here for gameplay, bpm is placeholder.
	Conductor = require("funkin.Conductor")(100)

	local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
	bg:centerPosition(Axis.XY)
	self:add(bg)

	self.hud = require("funkin.objects.hud.DefaultHUD")()
	self:add(self.hud)

	local Character = require("funkin.objects.Character")
	player = Character.load(Paths.getModule("data/characters/bf"))
	player.position.x = 640
	player.position.y = 480
	self:add(player)

	Sound.playMusic(Paths.getPath("ui/menu/bgm/freeplayRandom.ogg"), "stream", 0.7, true)

	Timer.create(0.25, function()
		self:beginCountdown(true)
	end, 0, true)
end

function Gameplay:update(dt)
	self.super.update(self,dt)
	if player then
		player.rotation = player.rotation + 0.01
	end
end

function Gameplay:keypressed(key)
	if key == "escape" then
		ScreenManager:switchScreen("funkin.screens.MainMenu")
	end
	if key == "d" then
		self.hud:displayJudgement("epic")
		self.hud:displayCombo(math.random(0, 1000000))
	end
end

local counter = 1
local countdownSprites = { "prepare", "ready", "set", "go" }
local countdownSounds = { "intro3", "intro2", "intro1", "introGo" }

function Gameplay:beginCountdown(silent)
	Timer.create(Conductor.crotchet, function()
		Gameplay:progressCountdown(silent)
		counter = counter + 1
	end, #countdownSounds, true)
end

function Gameplay:progressCountdown(silent)
	-- DISPLAY SPRITE
	if counter <= #countdownSprites then
		local counterTex = Paths.getImage("play/countdown/" .. countdownSprites[counter])
		if counterTex ~= nil then
			local countdownSprite = require("funkin.objects.PopupSprite")(0, 0, counterTex)
			countdownSprite:centerPosition(Axis.XY)
			local yy = countdownSprite.position.y
			self:add(countdownSprite)

			local ctime = Conductor.crotchet
			Timer.create(ctime + 0.001, function()
				countdownSprite:dispose()
			end)
			Tween.create(0.5, countdownSprite.position, { y = yy - 50 }, "inBack")
			Tween.create(ctime, countdownSprite, { alpha = 0.0 }, "inOutCubic")
		end
	end
	-- PLAY SOUND EFFECT
	if counter <= #countdownSounds and not silent then
		local audioPath = Paths.getPath("play/countdown/sfx/" .. countdownSounds[counter] .. ".ogg")
		if love.filesystem.getInfo(audioPath) ~= nil then
			local countdownSound = love.audio.newSource(audioPath, "static")
			countdownSound:setVolume(0.5)
			countdownSound:play()
			Timer.create(countdownSound:getDuration("seconds"), function()
				countdownSound:release()
			end, 0)
		end
	end
end

return Gameplay -- does this even do anything at ALL?
