local inifile = require "libraries.inifile"
if arg[2] == "debug" then
  require("lldebugger").start()
end

--#region Global

--- @class Colour
--- Utility containing functions and variables to work with colors
Colour = require("jigw.util.colour")
--- @alias Colour Color
Color = require("jigw.util.colour")
--- @class SceneManager
ScreenManager = require("jigw.screen_manager")
Utils = require("jigw.util.jigw_utils")

--#endregion

--- Date String, represents the current game version
--- this doesn't follow SemVer, and instead is the date
--- of when a version of the game was compiled
--- @type string
local game_ver = tostring(os.date("%Y.%m.%d"))

local system_font = love.graphics.newFont("assets/fonts/vcr.ttf", 16, "none")
local do_fps_draw = true

local game_canvas --- @type love.graphics.Canvas

function love.load()
  local x = "sm"
  Utils.match(x, {
    ["sm"] = function() print "Stepmania" end,
    ["fnf"] = function() print "Friday Night Funkin'" end,
    ["default"] = function() print "Unknown" end,
  })
  love.graphics.setFont(system_font)
  game_canvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
  ScreenManager:switch_screen("funkin.screens.main_menu")
end

function love.keypressed(key)
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:keypressed(key)
  end
end

function love.keyreleased(key)
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:keyreleased(key)
  end
end

function love.draw()
  local screen_w = love.graphics.getWidth()
  local screen_h = love.graphics.getHeight()

  love.graphics.setCanvas(game_canvas)
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill",0,0,game_canvas:getWidth(),game_canvas:getHeight())

  --- in game canvas ---
  love.graphics.setColor(1,1,1,1)
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:draw()
  end
  --- in main canvas ---
  love.graphics.setCanvas()
  love.graphics.setColor(1,1,1,1)
  love.graphics.clear(0.30,0.30,0.30,1.0)
  love.graphics.draw(game_canvas,
    (screen_w - game_canvas:getWidth()) * 0.5,
    (screen_h - game_canvas:getHeight()) * 0.5
  )
  if do_fps_draw then -- the fps counter should render over everything else.
    Utils.draw_text_with_stroke("FPS: "..love.timer.getFPS()
      .."\nRAM: "..Utils.format_bytes(get_memory())
      .."\nScreen: "..ScreenManager.active_screen.__name
      .."\nVersion: "..game_ver
      .."\nDraw Calls: "..love.graphics.getStats().drawcalls
      ,5,5)
  end
  --- -- ---- ------- ---
end

function get_memory()
  local img_mem = love.graphics.getStats().images
  local font_mem = love.graphics.getStats().fonts
  local canvas_mem = love.graphics.getStats().canvases
  return img_mem + font_mem + canvas_mem
end
