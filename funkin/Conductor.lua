local function buildConductor(self)
  sel.bpm = 100.0 --- @type number
  sel.crotchet = 0 --- @type number
  sel.semiquaver = 0 --- @type number
  sel.stepsPerBeat = 4 --- @type number
  -- we really just need these two, bars aren't gonna be used often
  -- i'll add them later if its really needed.
  sel.step = 0.0 --- @type number
  sel.beat = 0.0 --- @type number
  return sel
end
local Conductor = Object:extend()
function Conductor:__tostring() return "(Conductor Time "..self.time.." Beat "..self.beat.." Step"..self.step..")" end

function Conductor:new(startingBPM)
  buildConductor(self)
  if type(startingBPM) ~= "number" or startingBPM < 0 then
    startingBPM = 100.0
  end
  self.bpm = startingBPM
  return self
end

--#region Setters
function Conductor:set_bpm(vl)
  self.crotchet = (60/vl)
  self.semiquaver = (60/vl)*self.stepsPerBeat
  return rawset(self,self.bpm,vl)
end

function Conductor:set_stepsPerBeat(vl)
  self.semiquaver = (60/self.bpm)*vl
  return rawset(self,self.stepsPerBeat,vl)
end
--#endregion

return Conductor
