--- @enum Axis
Axis = {
  X   = 0x01,
  Y   = 0x02,
  XY  = 0x03,
}

if arg[2] == "debug" then
  require("lldebugger").start()
end

--- @return boolean
function string:last(pattern)
  return (self:sub(#self - #pattern + 1, #self) == pattern);
end

local split_t
local function gsplit(s) table.insert(split_t, s) end
--- @return table<string>
function string:split(sep, t)
  split_t = t or {}
  self:gsub((sep and sep ~= "") and "([^" .. sep .. "]+)" or ".", gsplit)
  return split_t
end

if not table.move then
  function table.move(a, f, e, t, b)
    b = b or a; for i = f, e do b[i + t - 1] = a[i] end
    return b
  end
end
function table.find(t, value) for i = 1, #t do if t[i] == value then return i end end end

local __number__ = "number"
local table_remove = table.remove or function(t, pos)
  local n = #t; if pos == nil then pos = n end;
  local v = t[pos]; if pos < n then table_move(t, pos + 1, n, pos) end;
  t[n] = nil; return v
end
function table.remove(list, idx)
  if idx == nil or type(idx) == __number__ then return table_remove(list, idx) end
  local j, v = 1
  for i = j, #list do
    if list[i] and idx(list, i, j) then
      v, list[i] = list[i]
    else
      if i ~= j then list[j], list[i] = list[i] end
      j = j + 1
    end
  end
  return v
end

function table:has(val)
  for i,v in next, self do
    if v == val then return true; end
  end
  return false
end

function math.round(x)
  return math.floor(x+0.5)
end

--#region Global

Object = require("libraries.classic") --- @class Object
Vector2 = require("jigw.util.Vector2") --- @class Vector2
Vector3 = require("jigw.util.Vector3") --- @class Vector3
Rect2 = require("jigw.util.Rect2") --- @class Rect2
Rect3 = require("jigw.util.Rect3") --- @class Rect3
ScreenTransitions = {
  Circle = require("jigw.transition.Circle"),
  Rectangle = require("jigw.transition.Rectangle"),
}
DefaultScreenTransition = ScreenTransitions.Circle

Color = require("jigw.util.Color")
ScreenHandler = require("jigw.ScreenHandler") --- @class ScreenHandler
Utils = require("jigw.util.EngineUtils") --- @class Utils
Timer = require("jigw.util.Timer") --- @class Timer
Tween = require("libraries.tween") --- @class Tween
Sound = require("jigw.Sound") --- @class Sound

_G.GlobalTweens = {} --- @type table<Tween>
_G.GlobalTimers = {} --- @type table<Timer>

--#endregion

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
  local screenPaused = ScreenHandler:isTransitionActive()
  if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.update then
    ScreenHandler.activeScreen:update(dt)
  end
  if Timer and #_G.GlobalTimers ~= 0 then
    local i = 1;
    while (i <= #_G.GlobalTimers)do
      local timer = _G.GlobalTimers[i];
      timer:update(dt);
      if timer.finished and timer.oneshot then
        table.remove(_G.GlobalTimers,i)
        --print('removed timer at ', i)
      end
      i = i + 1;
    end
  end
  if Tween and #_G.GlobalTweens ~= 0 then
    local i = 1;
    while i <= #_G.GlobalTweens do
      local tween = _G.GlobalTweens[i];
      tween:update(dt);
      if(_G.GlobalTweens[i].clock >= _G.GlobalTweens[i].duration)then
        table.remove(_G.GlobalTweens, i);
        --print('removed tween at ', i)
        return;
      end
      i = i + 1;
    end
  end
  if Sound and Sound.update then Sound.update(dt) end
  dtSince = dtSince + dt
end

function love.keypressed(key)
  local screenPaused = ScreenHandler:isTransitionActive()
  if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.keypressed then
    ScreenHandler.activeScreen:keypressed(key)
  end
end

function love.keyreleased(key)
  local screenPaused = ScreenHandler:isTransitionActive()
  if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.keyreleased then
    ScreenHandler.activeScreen:keyreleased(key)
  end
  -- temporary --
  if key == "-" or key == "kp-" then
    Sound.masterVolume = Utils.clamp(Sound.masterVolume - 0.05,0.0,1.0)
    Sound.playSound("assets/audio/sfx/soundtray/Voldown.ogg","static")
    print("Volume: "..(Sound.masterVolume*100))
  end
  if key == "=" or key == "kp+" then
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
    print("Volume Muted!")
  end
end

function love.draw()
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local defaultColor = Color.WHITE
  local defaultCanvas = love.graphics.getCanvas()

  love.graphics.setColor(defaultColor)
  love.graphics.setCanvas(gameCanvas)

  --- in game canvas ---
  if ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.draw then
    ScreenHandler.activeScreen:draw()
  end
  if ScreenHandler:isTransitionActive() then
    ScreenHandler.transition:draw()
    if ScreenHandler.transition.finished == true then
      ScreenHandler.transition = nil
    end
  end
  --- in main canvas ---
  love.graphics.setCanvas(defaultCanvas)
  love.graphics.clear(0.30,0.30,0.30,1.0)
  -- stretches the game's canvas.
  local sr = Vector2(screenWidth / gameCanvas:getWidth(),screenHeight / gameCanvas:getHeight())
  love.graphics.draw(gameCanvas,0,0,0,sr.x,sr.y)
  -- the fps counter should render over everything else.
  if drawFPSCounter then drawFPS(5+sr.x,5+sr.y) end
  --- --- ---- ------- ---
end

function love.quit()
end
