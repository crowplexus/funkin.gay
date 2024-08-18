JudgementManager = JudgementManager()

--- Judgments list.
--- @type table<[string, number, number, boolean]>
local judgments = {
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
--- @type number[]
local timings = { 18.9, 37.8, 75.6, 113.4, 180.0 }

--- judges a window of time and returns a judgement from it.
--- @param time number
--- @return table<[string, number, number, boolean]>
function JudgementManager:judge(time)
  local judge = judgments[#judgments]

  for i in #timings do -- loop through judgements
    if time <= timings[i] then -- get the matching one according to the timing
      judge = judgments[i]
      break
    end
  end

  return judge
end
