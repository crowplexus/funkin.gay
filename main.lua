--- @enum Axis
Axis = {
  X   = 0x01,
  Y   = 0x02,
  XY  = 0x03,
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

local systemFont = love.graphics.newFont("assets/fonts/vcr.ttf", 16, "none") --- @type love.Font
local drawFPSCounter = true --- @type boolean
local gameCanvas --- @type love.Canvas

local fpsCap = 60 --- @type number
local dtSince = 0 --- @type number

local defaultCanvas = love.graphics.getCanvas()

local bootStrapper = require("jigw.Boot")

local function getVRAM()
  local imgBytes = love.graphics.getStats().images --- @type number
  local fontBytes = love.graphics.getStats().fonts --- @type number
  local canvasBytes = love.graphics.getStats().canvases --- @type number
  return imgBytes + fontBytes + canvasBytes
end

local function drawFPS(x,y)
  local so = ScreenHandler:isScreenOperating()
  love.graphics.print("VRAM: "..Utils.formatBytes(getVRAM())
    ..(so and "\nScreen: "..ScreenHandler.activeScreen:__tostring() or "")
    .."\nDraw Calls: "..love.graphics.getStats().drawcalls,x,y)
end

function love.load()
  bootStrapper.init()
  -- set default font
  --love.graphics.setFont(systemFont)
  -- make a canvas for the actual game.
  local sz = Vector2(love.graphics.getWidth(),love.graphics.getHeight())
  gameCanvas = love.graphics.newCanvas(sz.x, sz.y)

  ScreenHandler.skipNextTransIn = true
  ScreenHandler.skipNextTransOut = true
  ScreenHandler:switchScreen("funkin.screens.MainMenu")
end

function love.update(dt)
  -- FRAMERATE CAP --
  local sleep = 1/fpsCap
  if dt < sleep then love.timer.sleep(sleep - dt) end
  bootStrapper.update(dt)
  dtSince = dtSince + dt
end

function love.keypressed(key)
  bootStrapper.keypressed(key)
end

function love.keyreleased(key)
  bootStrapper.keyreleased(key)
  -- temporary --
  if key == "-" or key == "kp-" then
		if Sound.masterMute == true then Sound.masterMute = false end
    Sound.masterVolume = Utils.clamp(Sound.masterVolume - 0.05,0.0,1.0)
    Sound.playSound("assets/audio/sfx/soundtray/Voldown.ogg","static")
    print("Volume: "..(Sound.masterVolume*100))
  end
  if key == "=" or key == "kp+" then
		if Sound.masterMute == true then Sound.masterMute = false end
    Sound.masterVolume = Utils.clamp(Sound.masterVolume + 0.05,0.0,1.0)
    if Sound.masterVolume < 1.0 then
      Sound.playSound("assets/audio/sfx/soundtray/Volup.ogg","static")
    else
      Sound.playSound("assets/audio/sfx/soundtray/VolMAX.ogg","static")
    end
    print("Volume: "..(Sound.masterVolume*100))
  end
  if key == "0" or key == "kp0" then
    Sound.masterMute = not Sound.masterMute
    Sound.playSound("assets/audio/sfx/soundtray/Voldown.ogg","static")
    if Sound.masterMute then print("Volume muted!")
		else print("Volume unmuted!") end
  end
end

function love.draw()
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local defaultColor = {1,1,1,1}
  local clearColor = Color.GRAY

  love.graphics.clear(clearColor)
  love.graphics.setCanvas(gameCanvas)

  --- in game canvas ---
  if ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.draw then
    ScreenHandler.activeScreen:draw()
  end
  if ScreenHandler.canTransition() then
    ScreenHandler.transition:draw()
    if ScreenHandler.transition.finished == true then
      ScreenHandler.transition = nil
    end
  end
  --- in main canvas ---
  love.graphics.setCanvas(defaultCanvas)
  -- kinda fixes the alpha issue but creates another where labels will be darkened
  -- TODO: fix colours being weird in-game
  love.graphics.setColor(defaultColor)
  -- stretches the game's canvas.
  local sr = Vector2(screenWidth / gameCanvas:getWidth(),screenHeight / gameCanvas:getHeight())
  love.graphics.draw(gameCanvas,0,0,0,sr.x,sr.y)
  -- the fps counter should render over everything else.
  if drawFPSCounter then drawFPS(5+sr.x,5+sr.y) end
  --- --- ---- ------- ---
end

function love.quit()
end
