local inifile = require "libraries.inifile"
if arg[2] == "debug" then
    require("lldebugger").start()
end

--#region Requires

--- @class Color
--- Utility containing functions and variables to work with colors
Color = require("jigw.util.colour")
--- @alias Colour Color
Colour = require("jigw.util.colour")
--- @class SceneManager
ScreenManager = require("jigw.screen_manager")

--#endregion

--#region Other Globals

Utils = {
    --- @param x number number of bytes to format.
    --- @param digits? number number of digits on the returning string, defaults to 2.
    --- @return string
    format_bytes = function(x, digits)
        if digits == nil or type(digits) ~= "string" then
            digits = 2
        end
        local units = {"B", "kB", "MB", "GB", "TB", "PB"}
        local unit = 3
        while x >= 1024 and unit < #units do
            x = x / 1024
            unit = unit + 1
        end
        return string.format("%."..digits.."f", x)..units[unit]
    end
}

--#endregion

--- Date String, represts the current game version
--- this doesn't follow SemVer, and instead is the date
--- of when a version of the game was compiled
--- @type string
local game_ver = tostring(os.date("%Y.%m.%d"))
local fps_font = love.graphics.newFont("assets/fonts/vcr.ttf", 16, "light")
local do_fps_draw = true

function love.load()
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
