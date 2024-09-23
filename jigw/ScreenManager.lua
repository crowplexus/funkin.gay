local ScreenManager = {
  __name = "Screen Manager",
  activeScreen = nil, --- @class Screen
  transition = nil,
  skipNextTransIn = false,
  skipNextTransOut = false,
}

--- Unloads the current screen and loads a new one
--- @param file string      Next screen module name
function ScreenManager:switchScreen(modname)
  local nextScreen = require(modname)
  -- in case the transition isn't set
  if not ScreenManager:willSkipTransition() and ScreenManager.transition == nil then
    ScreenManager.transition = DefaultScreenTransition
  end
  if ScreenManager:isTransitionActive() then -- is set, has draw
    ScreenManager.transition:reset()
    if ScreenManager.skipNextTransOut == false then
      ScreenManager.transition:outwards(true)
    end
  end
  local transitioned = true
  if ScreenManager:isTransitionActive() then
    transitioned = false
    ScreenManager.transition:reset()
    if ScreenManager.skipNextTransIn == false then
      ScreenManager.transition:inwards(true)
    end
  end

  doSwitch = function()
    if type(nextScreen) == "table" and transitioned then
      -- clear the previous screen.
      if ScreenManager:isScreenOperating() then
        ScreenManager.activeScreen:clear()
        if ScreenManager.activeScreen ~= nil then
          ScreenManager.activeScreen = nil
        end
      end
      -- enable the requested screen.
      if nextScreen.new then ScreenManager.activeScreen = nextScreen:new()
      else ScreenManager.activeScreen = nextScreen end
    end
    -- now that the new screen is set, enter it.
    if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.enter then
      ScreenManager.activeScreen:enter()
    end
  end
  if transitioned == true then doSwitch()
  else -- TODO: make this take transition duration into account idk.
    Timer.create(0.3,function()
      transitioned = true
      doSwitch()
    end)
  end

  ScreenManager.skipNextTransIn = false
  ScreenManager.skipNextTransOut = false
end

function ScreenManager:isTransitionActive()
  return ScreenManager.transition ~= nil and ScreenManager.transition.draw
end

function ScreenManager:willSkipTransition()
  return ScreenManager.skipNextTransOut and ScreenManager.skipNextTransIn
end

function ScreenManager:isScreenOperating()
  return ScreenManager.activeScreen ~= nil
end

function ScreenManager:getName()
  local named = ScreenManager.activeScreen ~= nil and ScreenManager.activeScreen.__name
  return named and ScreenManager.activeScreen.__name or tostring(ScreenManager.activeScreen)
end

return ScreenManager
