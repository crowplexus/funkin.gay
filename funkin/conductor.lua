local function reset_vars(con)
  con = {
    bpm = 100.0, --- @type number
    crotchet = (60 / Conductor.bpm), --- @type number
    semiquaver = (60 / Conductor.bpm) * 4.0, --- @type number
    steps_per_beat = 4, --- @type number
    -- we really just need these two, bars aren't gonna be used often
    -- i'll add them later if its really needed.
    step = 0.0, --- @type number
    beat = 0.0, --- @type number
  }
  return con
end
Conductor = reset_vars({})
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
  self.semiquaver = (60/vl)*self.steps_per_beat
  return rawset(self,self.bpm,vl)
end

function Conductor:set_steps_ber_beat(vl)
  self.semiquaver = (60/self.bpm)*vl
  return rawset(self,self.steps_per_beat,vl)
end
--#endregion

--#region Override Index
function Conductor:__index(idx)
  -- custom getter functionality
  if rawget(self,"get_"..idx) then return rawget(self,"get_"..idx)()
  else return rawget(self,idx) end
end

function Conductor:__newindex(idx,vl)
  -- custom setter functionality
  if rawget(self,"set_"..idx) then return rawget(self,"set_"..idx)(self,vl)
  else return rawset(self,idx,vl) end
end
--#endregion

return Conductor
