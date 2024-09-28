local Conductor = Object:extend() --- @class Conductor
function Conductor:__tostring() return "(Conductor Time "..self.time.." Beat "..self.beat.." Step"..self.step..")" end

function Conductor:new(startingBPM)
  self.bpm = 100.0 --- @type number
  self.crotchet = 0 --- @type number
  self.semiquaver = 0 --- @type number
  self.stepsPerBeat = 4 --- @type number
  self.time = 0.0 --- @type number
  -- we really just need these two, bars aren't gonna be used often
  -- i'll add them later if its really needed.
  self.step = 0.0 --- @type number
  self.beat = 0.0 --- @type number

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
