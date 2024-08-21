local ScreenManager = {
  __name = "Screen Manager",
  --- @class Screen
  activeScreen = require("jigw.Screen"),
}

--- Unloads the current screen and loads a new one
--- @param file string      Next screen module name
function ScreenManager:switchScreen(modname)
  local nextScreen = require(modname)
  if type(nextScreen) == "table" then
    -- clear the previous screen.
    if ScreenManager:isScreenOperating() then
      ScreenManager.activeScreen:clear()
      if ScreenManager.activeScreen ~= nil then
        ScreenManager.activeScreen = nil
      end
    end
    -- transform the requested screen into a metatable
    local nextInstance = {}
    nextInstance.__index = nextInstance
    setmetatable({}, nextScreen)
    -- enable the requested screen.
    if nextScreen.new then ScreenManager.activeScreen = nextScreen:new()
    else ScreenManager.activeScreen = nextScreen end
  end
  -- now that the new screen is set, enter it.
  if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.enter then
    ScreenManager.activeScreen:enter()
  end
end

function ScreenManager:isScreenOperating()
  return ScreenManager.activeScreen ~= nil
end

return ScreenManager
