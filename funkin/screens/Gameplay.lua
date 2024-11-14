local Gameplay = Screen:extend("Gameplay")

local Countdown = require("funkin.gameplay.hud.Countdown")
local ScriptsHandler = require("funkin.backend.scripting.ScriptsHandler")

local NoteField = require("funkin.gameplay.note.NoteField")
local Character = require("funkin.gameplay.Character")

local Player = require("funkin.gameplay.Player")
local players = {}

function Gameplay:enter()
	-- #region initialise game backend
	--local ChartLoader = require("funkin.backend.ChartLoader")
	--local chart = ChartLoader:readLegacy("2hot", "hard")
	--print("notes caught in the fire: " .. #chart.notes)

	-- make a conductor here for gameplay, bpm is placeholder.
	self.conductor = Conductor( --[[chart.bpm or]] 100)

	self.scriptsHandler = ScriptsHandler()
	self.scriptsHandler:loadDirectory("assets/data/scripts")
	self.scriptsHandler:call("enter")
	-- #endregion

	local vpw, vph = love.graphics.getDimensions()
	local ColorShape = require("jigw.objects.ColorShape")
	local bg = ColorShape(0, 0, Color.rgb(80, 80, 80), vpw, vph)
	bg:centerPosition(Axis.XY)
	self:add(bg)

	local boyfriend = Character.load(Paths.getModule("data/characters/bf"))
	boyfriend.position.y = 480
	boyfriend.position.x = 640
	self.boyfriend = boyfriend
	self:add(boyfriend)

	local vpw = love.graphics.getWidth()

	for i = 1, 2 do
		local noteX, noteY = (i == 1 and 50 or vpw * 0.5), 100
		local notefield = NoteField(noteX, noteY)
		players[i] = Player(i == 2, notefield)
		self:add(notefield)
	end

	local hud = require("funkin.gameplay.hud.GameplayHUD")()
	self.hud = hud
	self:add(hud)

	Timer.create(0.25, function()
		-- TODO: hudstyle system that changes the countdown that gets initialised or something of that genre
		Countdown.reset(self)
		Countdown.finishCallback = function()
			Sound.playMusic(Paths.getPath("ui/menu/bgm/stayFunky.ogg"), "stream", 0.3, true)
		end
		Countdown.start(false)
	end, 0, true)

	self.scriptsHandler:call("postEnter")
end

function Gameplay:update(dt)
	self.scriptsHandler:call("update")
	Gameplay.super.update(self, dt)
	self.scriptsHandler:call("postUpdate")
end

function Gameplay:keypressed(key)
	local controls = string.split("dfjk", "")
	local j = table.find(controls, key) or 0
	if j ~= 0 then players[1].notefield:playAnimation(j, "press", true) end

	if key == "escape" then
		ScreenManager:switchScreen("funkin.screens.MainMenu")
	end
	if key == "p" then
		self.hud:displayJudgement("epic")
		self.hud:displayCombo(math.random(0, 1000000))
	end
end

function Gameplay:keyreleased(key)
	local controls = string.split("dfjk", "")
	local j = table.find(controls, key) or 0
	if j ~= 0 then players[1].notefield:playAnimation(j, "static", true) end
end

return Gameplay
