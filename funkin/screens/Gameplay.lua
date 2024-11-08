local Gameplay = Screen:extend("Gameplay")

local PopupSprite = require("funkin.gameplay.hud.PopupSprite")
local Character = require("funkin.gameplay.Character")
local ScriptsHandler = require("funkin.backend.scripting.ScriptsHandler")

local player = nil

function Gameplay:enter()
	local vpw, vph = love.graphics.getDimensions()
	local ColorShape = require("jigw.objects.ColorShape")
	--local ChartLoader = require("funkin.backend.ChartLoader")
	--local chart = ChartLoader:readLegacy("2hot", "hard")
	--print("notes caught in the fire: " .. #chart.notes)

	-- make a conductor here for gameplay, bpm is placeholder.
	self.conductor = Conductor(--[[chart.bpm or]] 100)

	self.scriptsHandler = ScriptsHandler()
	self.scriptsHandler:loadDirectory("assets/data/scripts")
	self.scriptsHandler:call("enter")

	local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
	bg:centerPosition(Axis.XY)
	self:add(bg)

	player = Character.load(Paths.getModule("data/characters/bf"))
	player.position.x = 640
	player.position.y = 480
	self.player = player
	self:add(player)

	self.hud = require("funkin.gameplay.hud.DefaultHUD")()
	self:add(self.hud)

	Sound.playMusic(Paths.getPath("ui/menu/bgm/chartEditorLoop.ogg"), "stream", 0.3, true)

	Timer.create(0.25, function()
		self:beginCountdown(true)
	end, 0, true)

	self.scriptsHandler:call("postEnter")
end

function Gameplay:update(dt)
	self.scriptsHandler:call("update")
	Gameplay.super.update(self, dt)
	if player and player.texture then
		local fatnuts = {
			InputManager.getJustPressed("ui_left", true),
			InputManager.getJustPressed("ui_down", true),
			InputManager.getJustPressed("ui_up", true),
			InputManager.getJustPressed("ui_right", true),
		}
		for i = 1, #fatnuts do
			if fatnuts[i] == true then
				player:sing(i, true)
			end
		end
	end
	self.scriptsHandler:call("postUpdate")
end

function Gameplay:keypressed(key)
	if key == "escape" then
		ScreenManager:switchScreen("funkin.screens.MainMenu")
	end
	if key == "j" then
		self.hud:displayJudgement("epic")
		self.hud:displayCombo(math.random(0, 1000000))
	end
end

local counter = 1
local countdownSprites = { "prepare", "ready", "set", "go" }
local countdownSounds = { "intro3", "intro2", "intro1", "introGo" }

function Gameplay:beginCountdown(silent)
	Timer.create(Conductor.getCurrent().crotchet, function()
		Gameplay:progressCountdown(silent)
		counter = counter + 1
	end, #countdownSounds, true)
end

function Gameplay:progressCountdown(silent)
	-- DISPLAY SPRITE
	if counter <= #countdownSprites then
		local counterTex = Paths.getImage("play/countdown/" .. countdownSprites[counter])
		if counterTex ~= nil then
			local countdownSprite = PopupSprite(0, 0, counterTex)
			countdownSprite:centerPosition(Axis.XY)
			countdownSprite.acceleration.y = 300
			countdownSprite.velocity.y = countdownSprite.velocity.y - 130
			countdownSprite.moving = true
			countdownSprite.scale.x = 0.8
			countdownSprite.scale.y = 0.8
			self:add(countdownSprite)

			local ctime = Conductor.getCurrent().crotchet
			Timer.create(ctime + 0.001, function()
				countdownSprite:dispose()
			end)
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
