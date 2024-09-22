local Tally = Object:extend()
function Tally:__tostring() return "Tally" end
local function buildTally(sel)
  sel.score     = 0 --- @type number
  sel.misses    = 0 --- @type number
  sel.cbs       = 0 --- @type number
  sel.clear     = "NOPLAY" --- @type string
  sel.hitNotes  = 0 --- @type number
  sel.msAccum   = 0.00 --- @type number
  sel.grade     = "?" --- @type string
end

local gradeConditions = {
  {100,"SSSSS"}, {99,"SSSS"}, {98,"SSS"}, {96,"SS"}, -- the Stars
  {94,"S+"}, {92,"S"}, {89,"S-"}, -- the Ses
  {83,"A"}, {86,"A+"}, {80,"A-"}, -- the As
  {76,"B+"}, {72,"B"}, {68,"B-"}, -- the Bs
  {64,"C+"}, {60,"C"}, {50,"C-"}, -- the Cs
  {48,"D+"}, {45,"D"}, {10,"D-"}, -- the Dee. https://static.wikia.nocookie.net/kirby/images/6/67/KatFL_Waddle_Dee_artwork.png/revision/latest?cb=20220213193603&path-prefix=en
  {0,"F"}, {-100,"YOU SUCK"},     -- the you sucks
};

function Tally:new()
  buildTally(Tally)
  return self
end

function Tally:getAccuracy()
  return self.hitNotes == 0 and 0.00 or (self.hitNotes/self.msAccum)
end

function Tally:getCurrentGrade()
  if self.hitNotes == 0 then return "?" end
  return Tally.getGrade(self:getAccuracy())
end

function Tally.getGrade(acc)
  if not acc or type(acc) ~= "number" then acc = 100 end
  local grade = gradeConditions[1][2]
  if acc < 100 then
    --#region GradeCalc
    for i=1,#gradeConditions do
      local newgrade = gradeConditions[i]
      if acc >= newgrade[1] then
        grade = newgrade[2]
        break
      end
    end
    --#endregion
  end

  return grade
end

return Tally