Conductor = Conductor()

Conductor.bpm = 100.0
Conductor.crotchet = (60 / Conductor.bpm)
Conductor.semiquaver = (60 / Conductor.bpm) * 4.0

function Conductor:init()
end
