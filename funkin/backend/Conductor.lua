--- Handles time and synching for the whole game.
--- @class Conductor
local Conductor = Classic:extend("Conductor")

--- we need this for some time-related stuff
local TimeUtil = require("funkin.TimeUtil")

--- Returns the conductor for the current screen,
--- or a fake one if there's none.
--- @return table
function Conductor.getCurrent()
  ---@diagnostic disable-next-line: missing-parameter
  return ScreenManager.activeScreen.conductor or TimeUtil.makeFakeConductor()
end

function Conductor:__tostring()
  return "(Conductor Time " .. self.time .. " Beat " .. self.beat .. " Step" .. self.step .. ")"
end

--- Makes a new conductor.
--- @param startingBPM? number starting BPM value, defaults to 100.
function Conductor:construct(startingBPM)
  if type(startingBPM) ~= "number" or startingBPM < 0 then
    startingBPM = 100.0
  end
  self.bpm = startingBPM                  --- @type number
  self.crotchet = (60 / self.bpm)         --- @type number
  self.semiquaver = (60 / self.bpm) * 4.0 --- @type number
  self.stepsPerBeat = 4                   --- @type number
  self.time = 0.0                         --- @type number
  -- we really just need these two, bars aren't gonna be used often
  -- i'll add them later if its really needed.
  self.step = 0.0 --- @type number
  self.beat = 0.0 --- @type number
end

function Conductor:set_bpm(vl)
  rawset(self, "crotchet", TimeUtil.calculateCrotchet(vl))
  rawset(self, "semiquaver", TimeUtil.calculateCrotchet(vl) * 4.0)
  return rawset(self, "bpm", vl)
end

return Conductor
