if arg[2] == "debug" then
  require("lldebugger").start()
end

function string:endsWith(pattern)
  return (self:sub(#self - #pattern + 1, #self) == pattern);
end

function table:has(val)
  for i,v in next, self do
    if v == val then
    return true;
  end
end
return false
end

function math:round(x)
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
ScreenManager = require("jigw.ScreenManager") --- @class ScreenManager
Utils = require("jigw.util.JigwUtils") --- @class Utils
Timer = require("jigw.util.Timer") --- @class Timer
Tween = require("libraries.tween") --- @class Tween

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

function love.load()
  -- set default font
  love.graphics.setFont(systemFont)
  -- make a canvas for the actual game.
  local sz = Vector2(love.graphics.getWidth(),love.graphics.getHeight())
  gameCanvas = love.graphics.newCanvas(sz.x, sz.y)

  ScreenManager.skipNextTransIn = true
  ScreenManager.skipNextTransOut = true
  ScreenManager:switchScreen("funkin.screens.Gameplay")
end

function love.update(dt)
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.update then
    ScreenManager.activeScreen:update(dt)
  end
  if Timer and #Timer.list ~= 0 then

    local i = 1;
    while (i <= #Timer.list)do
      local timer = Timer.list[i];
      timer:update(dt);
      if timer.finished and timer.oneshot then
        table.remove(Timer.list,i)
      end
      i = i + 1;
    end

  end
end

function love.keypressed(key)
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.keypressed then
    ScreenManager.activeScreen:keypressed(key)
  end
end

function love.keyreleased(key)
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.keyreleased then
    ScreenManager.activeScreen:keyreleased(key)
  end
end

function love.draw()
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local defaultColor = Color.WHITE

  love.graphics.setColor(defaultColor)
  love.graphics.setCanvas(gameCanvas)

  --- in game canvas ---
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.draw then
    ScreenManager.activeScreen:draw()
  end
  if ScreenManager:isTransitionActive() then
    ScreenManager.transition:draw()
    if ScreenManager.transition.finished == true then
      ScreenManager.transition = nil
    end
  end
  --- in main canvas ---
  love.graphics.setCanvas()
  love.graphics.clear(0.30,0.30,0.30,1.0)
  -- stretches the game's canvas.
  local sr = Vector2(screenWidth / gameCanvas:getWidth(),screenHeight / gameCanvas:getHeight())
  love.graphics.draw(gameCanvas,0,0,0,sr.x,sr.y)
  -- the fps counter should render over everything else.
  if drawFPSCounter then drawFPS(5+sr.x,5+sr.y) end
  --- --- ---- ------- ---
end

function drawFPS(x,y)
  local so = ScreenManager:isScreenOperating()
  Utils.drawText("FPS: "..love.timer.getFPS()
    .." - RAM: "..Utils.formatBytes(getMemoryUsage())
    ..(so and "\nScreen: "..ScreenManager.activeScreen:__tostring() or "")
    .." - Draw Calls: "..love.graphics.getStats().drawcalls
    ,x,y)
end

local fuck = true

function love.quit()
end

function getMemoryUsage()
  local imgBytes = love.graphics.getStats().images --- @type number
  local fontBytes = love.graphics.getStats().fonts --- @type number
  local canvasBytes = love.graphics.getStats().canvases --- @type number
  return imgBytes + fontBytes + canvasBytes
end
