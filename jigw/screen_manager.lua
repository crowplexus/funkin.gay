local ScreenManager = {
  __name = "Screen Manager",
  --- @class Screen
  active_screen = require("jigw.screen"),
}

--- Unloads the current screen and loads a new one
--- @param file string      Next screen module name
function ScreenManager:switch_screen(modname)


  local next_screen = require(modname)
  if type(next_screen) == "table" then
    -- clear the previous screen.
    if ScreenManager:screen_active() then
      ScreenManager.active_screen:clear()
      ScreenManager.active_screen = nil
    end
    -- transform the requested screen into a metatable
    local next_instance = {}
    setmetatable({}, next_screen)
    next_instance.__index = next_instance
    -- enable the requested screen.
    if next_screen.new then ScreenManager.active_screen = next_screen:new()
    else ScreenManager.active_screen = next_screen end
  end
  -- now that the new screen is set, enter it.
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:enter()
  end
end

function ScreenManager:screen_active()
  return ScreenManager.active_screen ~= nil
end

return ScreenManager
