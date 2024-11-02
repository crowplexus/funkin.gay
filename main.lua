--- @enum Axis
Axis = {
	X = 0x01,
	Y = 0x02,
	XY = 0x03,
}

if arg[2] == "debug" then
	require("lldebugger").start()
end

--- Date String, represents the current game version
--- this doesn't follow SemVer, and instead is the date
--- of when a version of the game was compiled
--- @type string
_G.GAME_VER = tostring(os.date("%Y.%m.%d"))

_G.PROJECT = require("project")

Paths = require("funkin.data.Paths")
Translator = require("funkin.data.Translator")

local drawFPSCounter = true --- @type boolean
local gameCanvas --- @type love.Canvas

local jigwBootstrapper = require("jigw.Boot") --- @class jigw.Boot

local function getVRAM()
	local imgBytes = love.graphics.getStats().images --- @type number
	local fontBytes = love.graphics.getStats().fonts --- @type number
	local canvasBytes = love.graphics.getStats().canvases --- @type number
	return imgBytes + fontBytes + canvasBytes
end

local function drawFPS(x, y)
	local so = ScreenManager:isScreenOperating()
	love.graphics.print(
		"VRAM: "
			.. Utils.formatBytes(getVRAM())
			.. (so and "\nScreen: " .. ScreenManager.activeScreen:__tostring() or "")
			.. "\nDraw Calls: "
			.. love.graphics.getStats().drawcalls,
		x,
		y
	)
end

function love.load()
	jigwBootstrapper.init()
	require("funkin.data.Global") -- import funkin stuff

	--- TODO: get locale list -> Translator.parseListed("id-ID")
	if _G.PROJECT.allowLocales == true then
		Translator.parseFile(Paths.getPath("data/locale/en.ini"), true)
	end
	-- make a canvas for the actual game.
	local sz = { x = love.graphics.getWidth(), y = love.graphics.getHeight() }
	gameCanvas = love.graphics.newCanvas(sz.x, sz.y)

	-- bind default actions (temporary until savedata is made)
	InputManager.rebindAction("ui_left", { "a", "left" })
	InputManager.rebindAction("ui_down", { "s", "down" })
	InputManager.rebindAction("ui_up", { "w", "up" })
	InputManager.rebindAction("ui_right", { "d", "right" })
	InputManager.rebindAction("ui_accept", { "return" })
	InputManager.rebindAction("ui_cancel", { "escape", "backspace" })

	-- switch to the main menu screen for now.
	ScreenManager.skipNextTransIn = true
	ScreenManager.skipNextTransOut = true
	ScreenManager:switchScreen("funkin.screens.Gameplay")
end

local fpsCap = 60 --- @type number
local dtSince = 0 --- @type number

function love.update(dt)
	-- FRAMERATE CAP --
	local sleep = 1 / fpsCap
	if dt < sleep then
		love.timer.sleep(sleep - dt)
	end
	jigwBootstrapper.update(dt)
	dtSince = dtSince + dt
end

function love.keypressed(key)
	jigwBootstrapper.keypressed(key)
end

function love.keyreleased(key)
	jigwBootstrapper.keyreleased(key)
	-- #region Soundtray (temporary)
	if key == "-" or key == "kp-" then
		if Sound.masterMute == true then
			Sound.masterMute = false
		end
		Sound.masterVolume = Utils.clamp(Sound.masterVolume - 0.15, 0.0, 1.0)
		Sound.playSound(Paths.getPath("ui/soundtray/sfx/Voldown.ogg"), "static")
		print("Volume: " .. (Sound.masterVolume * 100))
	end
	if key == "=" or key == "kp+" then
		if Sound.masterMute == true then
			Sound.masterMute = false
		end
		Sound.masterVolume = Utils.clamp(Sound.masterVolume + 0.15, 0.0, 1.0)
		if Sound.masterVolume < 1.0 then
			Sound.playSound(Paths.getPath("ui/soundtray/sfx/Volup.ogg"), "static")
		else
			Sound.playSound(Paths.getPath("ui/soundtray/sfx/VolMAX.ogg"), "static")
		end
		print("Volume: " .. (Sound.masterVolume * 100))
	end
	if key == "0" or key == "kp0" then
		Sound.masterMute = not Sound.masterMute
		Sound.playSound(Paths.getPath("ui/soundtray/sfx/Voldown.ogg"), "static")
		if Sound.masterMute then
			print("Volume muted!")
		else
			print("Volume unmuted!")
		end
	end
	--#endregion
end

function love.draw()
	local screenWidth, screenHeight = love.graphics.getDimensions()
	local clearCanvas = function()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.clear(Color.GRAY())
	end
	gameCanvas:renderTo(function()
		clearCanvas()
		if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.draw then
			ScreenManager.activeScreen:draw()
		end
		if ScreenManager.canTransition() then
			ScreenManager.transition:draw()
			if ScreenManager.transition.finished == true then
				ScreenManager.transition = nil
			end
		end
	end)

	love.graphics.setCanvas()
	clearCanvas()
	-- stretches the game's canvas.
	local srx, sry = screenWidth / gameCanvas:getWidth(), screenHeight / gameCanvas:getHeight()
	love.graphics.draw(gameCanvas, 0, 0, 0, srx, sry)
	-- the fps counter should render over everything else.
	if drawFPSCounter then
		drawFPS(5 + srx, 5 + sry)
	end
	--- --- ---- ------- ---
end
