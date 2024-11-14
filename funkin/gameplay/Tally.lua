local Tally = Classic:extend("Tally")

local gradeConditions = {
  score = { 100, 90, 80, 60, 40, -1 },
  ranks = { "P", "E", "GT", "GD", "S", "L" },
  names = { "Perfect", "Excellent", "Great", "Good", "Shit", "Loss" },
}

function Tally.getGrade(acc)
  local grade = gradeConditions.ranks[1] -- Perfect
  acc = acc or 100
  if acc >= 100 then
    return grade -- already correct
  end
  for i = 1, #gradeConditions do
    if acc >= gradeConditions.score[i] then
      grade = gradeConditions.ranks[i]
      break
    end
  end
  return grade
end

function Tally:construct()
  self.score    = 0        --- @type number
  self.misses   = 0        --- @type number
  self.cbs      = 0        --- @type number
  self.clear    = "NOPLAY" --- @type string
  self.hitNotes = 0        --- @type number
  self.msAccum  = 0.00     --- @type number
  self.grade    = "?"      --- @type string
  return self
end

function Tally:getAccuracy()
  return self.hitNotes == 0 and 0.00 or (self.hitNotes / self.msAccum)
end

function Tally:getCurrentGrade()
  if self.hitNotes == 0 then return "?" end
  return Tally.getGrade(self:getAccuracy())
end

return Tally
