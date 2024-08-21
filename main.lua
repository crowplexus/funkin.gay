if arg[2] == "debug" then
  require("lldebugger").start()
end

--#region Global

Object = require("libraries.classic")

Point2 = require("jigw.util.Point2")
Point3 = require("jigw.util.Point3")
Rect2 = require("jigw.util.Rect2")
Rect3 = require("jigw.util.Rect3")

--- @class Colour
--- Utility containing functions and variables to work with colors
Colour = require("jigw.util.Colour")
--- @alias Colour Color
Color = require("jigw.util.Colour")
--- @class SceneManager
ScreenManager = require("jigw.ScreenManager")
Utils = require("jigw.util.JigwUtils")

--#endregion

--- Date String, represents the current game version
--- this doesn't follow SemVer, and instead is the date
--- of when a version of the game was compiled
--- @type string
gameVersion = tostring(os.date("%Y.%m.%d"))

local systemFont = love.graphics.newFont("assets/fonts/vcr.ttf", 16, "none")
local drawFPSCounter = true --- @type boolean

local gameCanvas --- @type love.graphics.Canvas

function love.load()
  love.graphics.setFont(systemFont) -- set default font
  gameCanvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
  ScreenManager:switchScreen("funkin.screens.MainMenu")
end

function love.update()
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.update then
    ScreenManager.activeScreen:update(love.timer.getDelta())
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
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  love.graphics.setCanvas(gameCanvas)
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill",0,0,gameCanvas:getWidth(),gameCanvas:getHeight())

  --- in game canvas ---
  love.graphics.setColor(1,1,1,1)
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.draw then
    ScreenManager.activeScreen:draw()
  end
  --- in main canvas ---
  love.graphics.setCanvas()
  love.graphics.setColor(1,1,1,1)
  love.graphics.clear(0.30,0.30,0.30,1.0)
  love.graphics.draw(gameCanvas,
    (screenWidth - gameCanvas:getWidth()) * 0.5,
    (screenHeight - gameCanvas:getHeight()) * 0.5
  )
  if drawFPSCounter then -- the fps counter should render over everything else.
    Utils.drawTextWithStroke("FPS: "..love.timer.getFPS()
      .." - RAM: "..Utils.formatBytes(getMemoryUsage())
      .."\nScreen: "..ScreenManager.getName()
      .." - Draw Calls: "..love.graphics.getStats().drawcalls
      ,5,5)
  end
  --- -- ---- ------- ---
end

function love.quit()
end

function getMemoryUsage()
  local imgBytes = love.graphics.getStats().images --- @type number
  local fontBytes = love.graphics.getStats().fonts --- @type number
  local canvasBytes = love.graphics.getStats().canvases --- @type number
  return imgBytes + fontBytes + canvasBytes
end
