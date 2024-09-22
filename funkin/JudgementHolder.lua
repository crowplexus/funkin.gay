-- Contains a Judgement List + tools to work with said list.
local JudgementHolder = Object:extend() --- @class JudgementHolder
function JudgementHolder:__tostring() return "JudgementHolder" end
local function buildJudgementHolder(sel)
  sel.counters = {} --- @type table<string>
  for i=1,#list do
    table.insert(sel.counters,0,#sel.counters)
  end
  return sel
end

local list = JudgementHolder.getList()
local timings = JudgementHolder.getTimings()

function JudgementHolder:new()
  buildJudgementHolder(self)
  return self
end

--- Judgements list.
---
--- constructed like this:
---
--- ```lua
--- { "Display Name", score, accuracy, note_splash }
--- ```
---
--- @return table<[string, number, number, boolean]>
function JudgementHolder.getList()
  return {
    --            good judges               --
    {   "Epic",   350,    100.0,    true    },
    {   "Sick",   250,    90.0,     true    },
    {   "Good",   50,     50.0,     false   },
    --            skill issue :/            --
    {   "Bad",    -50,    0.0,      false   },
    {   "Shit",   -100,   -10.0,    false   },
    {   "Miss",   -150,   -30.0,    false   },
    --            ------------              --
  }
end

--- @return table<number>
function JudgementHolder.getTimings()
  return { 18.9, 37.8, 75.6, 113.4, 180.0 }
end

--- Judges a window of time and returns a judgement from it.
--- @param time number
--- @return table<[string, number, number, boolean]>
function JudgementHolder:judge(time)
  local judge = list[#list] -- the one at the bottom
  for i=1, #timings do -- no way we're doing a for loop :shocked_face:
    if time <= timings[i] then -- get the matching one according to the timing
      judge = list[i]
      break
    end
  end
  return judge
end

return JudgementHolder
