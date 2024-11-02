local Conductor = Classic:extend("Conductor") --- @class Conductor
function Conductor:__tostring()
	return "(Conductor Time "..self.time.." Beat "..self.beat.." Step"..self.step..")"
end

function Conductor.makeDummy(phBpm)
  local _bpm = phBpm or 100.0
  return {
    bpm = _bpm, --- @type number
    crotchet = (60 / _bpm), --- @type number
    semiquaver = (60 / _bpm) * 4.0, --- @type number
    time = 0.0, --- @type number
    step = 0.0, --- @type number
    beat = 0.0, --- @type number
  }
end

function Conductor:construct(startingBPM)
   if type(startingBPM) ~= "number" or startingBPM < 0 then
    startingBPM = 100.0
  end
  self.bpm = startingBPM --- @type number
  self.crotchet = (60 / self.bpm) --- @type number
  self.semiquaver = (60 / self.bpm) * 4.0 --- @type number
  self.stepsPerBeat = 4 --- @type number
  self.time = 0.0 --- @type number
  -- we really just need these two, bars aren't gonna be used often
  -- i'll add them later if its really needed.
  self.step = 0.0 --- @type number
  self.beat = 0.0 --- @type number
end

function Conductor.calculateCrotchet(bpmVal)
	if type(bpmVal) ~= "number" then
		bpmVal = 100
	end
	return (60 / bpmVal)
end

function Conductor.getActive()
  return ScreenManager.activeScreen["Conductor"] or Conductor.makeDummy()
end

function Conductor:set_bpm(vl)
  rawset(self, "crotchet", Conductor.calculateCrotchet(vl))
  rawset(self, "semiquaver", Conductor.calculateCrotchet(vl) * 4.0)
  return rawset(self, "bpm", vl)
end

return Conductor
