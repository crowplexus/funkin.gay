local function resetVars()
  return {
    bpm = 100.0, --- @type number
    crotchet = (60 / Conductor.bpm), --- @type number
    semiquaver = (60 / Conductor.bpm) * 4.0, --- @type number
    stepsPerBeat = 4, --- @type number
    -- we really just need these two, bars aren't gonna be used often
    -- i'll add them later if its really needed.
    step = 0.0, --- @type number
    beat = 0.0, --- @type number
  }
end
Conductor = resetVars({})
Conductor.__index = Conductor

function Conductor:init(starting_bpm)
  if type(starting_bpm) ~= "number" or starting_bpm < 0 then
    starting_bpm = 100.0
  end
  self.bpm = starting_bpm
end

--#region Setters
function Conductor:set_bpm(vl)
  self.crotchet = (60/vl)
  self.semiquaver = (60/vl)*self.stepsPerBeat
  return rawset(self,self.bpm,vl)
end

function Conductor:set_steps_ber_beat(vl)
  self.semiquaver = (60/self.bpm)*vl
  return rawset(self,self.stepsPerBeat,vl)
end
--#endregion

--#region Override Index
function Conductor:__index(idx)
  -- custom get variable functionality
  return rawget(self,"get_"..idx) and rawget(self,"get_"..idx)() or rawget(self,idx)
end

function Conductor:__newindex(idx,vl)
  -- custom set variable functionality
  return rawget(self,"set_"..idx) and rawget(self,"set_"..idx)(self,vl) or rawset(self,idx,vl)
end
--#endregion

return Conductor
