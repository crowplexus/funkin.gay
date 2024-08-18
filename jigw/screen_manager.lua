local ScreenManager = {
  __name = "Screen Manager",
  --- @class Screen
  active_screen = require("jigw.screen"),
}

--- Unloads the current screen and loads a new one
--- @param file string      Next screen file name
function ScreenManager:switch_screen(file)
  local next_screen = require(file)
  if type(next_screen) == "table" then
    if not next_screen then return end
    if ScreenManager.active_screen ~= nil then
      ScreenManager.active_screen.clear() end
    ScreenManager.active_screen = next_screen
  end
  if ScreenManager:screen_active() then
    ScreenManager.active_screen:enter()
  end
end

function ScreenManager:screen_active()
  return ScreenManager.active_screen ~= nil
end

return ScreenManager
