local Gameplay = Screen:extend("Gameplay")

local PopupSprite = require("funkin.gameplay.hud.PopupSprite")
local ScriptsHandler = require("funkin.backend.scripting.ScriptsHandler")

local NoteField = require("funkin.gameplay.note.NoteField")
local Character = require("funkin.gameplay.Character")

local Player = require("funkin.gameplay.Player")
local players = {}

function Gameplay:enter()
	local vpw, vph = love.graphics.getDimensions()
	local ColorShape = require("jigw.objects.ColorShape")
	--local ChartLoader = require("funkin.backend.ChartLoader")
	--local chart = ChartLoader:readLegacy("2hot", "hard")
	--print("notes caught in the fire: " .. #chart.notes)

	-- make a conductor here for gameplay, bpm is placeholder.
	self.conductor = Conductor( --[[chart.bpm or]] 100)

	self.scriptsHandler = ScriptsHandler()
	self.scriptsHandler:loadDirectory("assets/data/scripts")
	self.scriptsHandler:call("enter")

	local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
	bg:centerPosition(Axis.XY)
	self:add(bg)

	self.boyfriend = Character.load(Paths.getModule("data/characters/bf"))
	self.boyfriend.position.y = 480
	self.boyfriend.position.x = 640
	self:add(self.boyfriend)

	local vpw = love.graphics.getWidth()

	for i = 1, 2 do
		local noteX, noteY = (i == 1 and 50 or vpw * 0.5), 100
		local notefield = NoteField(noteX, noteY)
		players[i] = Player(i == 2, notefield)
		self:add(notefield)
	end

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

	for i = 1, #players do
		if players[i].autoplay == true then
			return
		end
		for _, action in ipairs(players[i].controls) do
			local pressed = love.keyboard.isDown(action)
			local released = love.keyboard.isUp(action)
			if j ~= 0 and j < #ctrls then
				if pressed == true then
					Player.handleInput(players[i], action)
				elseif released == true then
					Player.handleRelease(players[i], action)
				end
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
