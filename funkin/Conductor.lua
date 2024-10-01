local Conductor = Object:extend() --- @class Conductor
function Conductor:__tostring()
	return "(Conductor Time "..self.time.." Beat "..self.beat.." Step"..self.step..")"
end

function Conductor:new(startingBPM)
   if type(startingBPM) ~= "number" or startingBPM < 0 then
    startingBPM = 100.0
  end
  self.crotchet = 0 --- @type number
  self.semiquaver = 0 --- @type number
  self.stepsPerBeat = 4 --- @type number
  self.time = 0.0 --- @type number
  -- we really just need these two, bars aren't gonna be used often
  -- i'll add them later if its really needed.
  self.step = 0.0 --- @type number
  self.beat = 0.0 --- @type number
  self.bpm = startingBPM --- @type number
  return self
end

function Conductor.calculateCrotchet(bpmVal)
	if type(bpmVal) ~= "number" then
		bpmVal = 100
	end
	return (60 / bpmVal)
end

--#region Setters
function Conductor:set_bpm(vl)
  self.crotchet = Conductor.calculateCrotchet(vl)
  self.semiquaver = Conductor.calculateCrotchet(vl) * self.stepsPerBeat
  return rawset(self, "bpm", vl)
end

function Conductor:set_stepsPerBeat(vl)
  self.semiquaver = Conductor.calculateCrotchet(self.bpm) * vl
	return rawset(self, "stepsPerBeat", vl)
end
--#endregion

return Conductor
