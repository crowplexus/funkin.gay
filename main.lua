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

local fps_font = love.graphics.newFont("assets/fonts/vcr.ttf", 14, "none")
local do_fps_draw = true

function love.load()
  local x = "sm"
  Utils.match(x, {
    ["sm"] = function() print "Stepmania" end,
    ["fnf"] = function() print "Friday Night Funkin'" end,
    ["default"] = function() print "Unknown" end,
  })
  ScreenManager:switch_screen("funkin.screens.main_menu")
end

function love.draw()
  love.graphics.clear(0.30,0.30,0.30,1.0)
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:draw()
  end
  if do_fps_draw then -- the fps counter should render over everything else.
    love.graphics.print("FPS: "..love.timer.getFPS()
      .."\nRAM: "..Utils.format_bytes(love.graphics.getStats().images)
      .."\nScreen: "..ScreenManager.active_screen.__name
      .."\nVersion "..game_ver
      ,fps_font,5,5)
  end
end
