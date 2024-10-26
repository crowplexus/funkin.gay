local DefaultHUD = Object:extend("DefaultHUD")
local judgeHolder = require("funkin.JudgementHolder")
local PopupSprite = require("funkin.objects.PopupSprite")

local function getScoreText(tally)
  local scrRep   = tally and Utils.thousandSep(tally.score) or "0"
  local accRep   = tally and string.format("%.2f", tally:getAccuracy()) or "0.00"
  local clearRep = tally and tally.clear or "(NOPLAY) "
  local gradeRep = tally and tally:getCurrentGrade() or ""
  if _G.PROJECT.allowLocales == true then
    return Translator.getString("scoreText","Gameplay",{scrRep,accRep,clearRep,gradeRep})
    --return Translator.getString("scoreText","Gameplay",{scrRep,accRep,clearRep,gradeRep})
  else
    return "Score:"..scrRep
    --return "Score: "..scrRep .." | Accuracy: "..accRep.."%" .." | "..clearRep..gradeRep
  end
end

local function getJudges()
  local str = ""
  local judges = judgeHolder.getList()
  for i = 1, #judges do
  	str = str .. judgeHolder.judgeToPlural(judges[i][1]) .. ": 0\n"
  end
  return str
end

function DefaultHUD:new()
	DefaultHUD.super.new()

	self.scoreText = nil --- @class jigw.objects.Label
	self.judgementCounter = nil --- @class jigw.objects.Label
  self.comboSprites = {} --- @class table<funkin.objects.PopupSprite>

	local Label = require("jigw.objects.Label")
  local ProgressShape = require("jigw.objects.ProgressShape")
  local vpw, vph = love.graphics.getDimensions()

  local downscroll = true
  local healthBarY = downscroll and vpw * 0.05 or vpw * 0.5

  self.healthBar = ProgressShape(0,healthBarY,590,10)
  self.healthBar.colors = { Color.rgb(255,0,0), Color.rgb(102,255,51) }
  self.healthBar.percentage = 50 -- center the primary rectangle in the bar
  self.healthBar.fillMode = ProgressFill.RTL -- LTR, RTL, BTT, TTB
  self.healthBar:centerPosition(Axis.X)

	self.scoreText = Label(0, healthBarY + self.healthBar:getHeight() + 15, getScoreText(), 16)
  self.scoreText.position.x = self.healthBar.position.x + self.healthBar:getWidth() - 190
  --self.scoreText.position.y = (vph - self.scoreText.size.y) - 15
  self.scoreText:changeFontFromPath("assets/ui/fonts/vcr.ttf")
  --self.scoreText:centerPosition(Axis.X)
  self.scoreText.strokeSize = 1.0

  --self.judgementCounter = Label(5, 0, getJudges(), 18)
  --self.judgementCounter:changeFontFromPath("assets/ui/fonts/vcr.ttf")
  --self.judgementCounter.position.y = (vph - self.judgementCounter.size.y) * 0.5
  --self.judgementCounter.strokeSize = 1.25

  --self:add(self.healthBar)
  --self:add(self.scoreText)
  --self:add(self.judgementCounter)
end

function DefaultHUD:update(dt)
  if self.comboSprites and #self.comboSprites ~= 0 then
    for i=1,#self.comboSprites do
      local judge = self.comboSprites[i]
      if judge and judge.update then judge:update(dt) end
    end
  end
end

function DefaultHUD:draw()
	-- TODO: better way to draw here??? idk
	if self.healthBar and self.healthBar.draw then self.healthBar:draw() end
	if self.scoreText and self.scoreText.draw then self.scoreText:draw() end
	if self.judgementCounter and self.judgementCounter.draw then self.judgementCounter:draw() end
  if self.comboSprites and #self.comboSprites ~= 0 then
    for i=1,#self.comboSprites do
      local judge = self.comboSprites[i]
      if judge and judge.draw then
        judge:draw()
        if judge.alpha <= 0.0 then
          judge:dispose()
          table.remove(self.comboSprites,i)
        end
      end
    end
  end
  --print(shit and "pong" or "ping")
end

function DefaultHUD:displayJudgement(name,offsetx,offsety)
  local tex = love.graphics.newImage("assets/play/scoring/"..name..".png")
  if not tex then return end
  local judgement = PopupSprite(0,0,tex)
  if judgement then
    judgement:centerPosition(Axis.XY)
    judgement.position.x = judgement.position.x + (offsetx or 0)
    judgement.position.y = judgement.position.y + (offsety or 0)
    judgement.moving = true
    judgement.scale.x = 0.65
    judgement.scale.y = 0.65
    judgement.acceleration.y = 550
    judgement.velocity.y = judgement.velocity.y - math.random(140,175)
    judgement.velocity.x = judgement.velocity.x - math.random(  0, 10)
    table.insert(self.comboSprites,judgement)

    Tween.create(0.2, judgement, { alpha = 0.0 }, "linear", nil, 0.5)
  end
end

function DefaultHUD:displayCombo(comboCount)
  assert(comboCount, "comboCount value in displayCombo function must be a number!")
  comboCount = math.round(comboCount)
  local comboTable = string.split(tostring(comboCount),"")
  local xOff = #comboTable - 3

  for i=1,#comboTable do
    local digit = comboTable[i]
    local tex = love.graphics.newImage("assets/play/scoring/num"..digit..".png")
    if not tex then return end
    local comboDigit = PopupSprite(0,0,tex)
    if comboDigit then
      comboDigit.moving = true
      comboDigit.scale.x = 0.45
      comboDigit.scale.y = 0.45

      comboDigit:centerPosition(Axis.XY)

      local offset = ((90 * comboDigit.scale.x) * (i - xOff)) - 60
      comboDigit.position.x = (comboDigit.position.x) + offset
      comboDigit.position.y = (comboDigit.position.y + comboDigit:getHeight()) - 30

      comboDigit.velocity.x = math.random(-5, 5)
      comboDigit.acceleration.y = math.random(250, 300);
      comboDigit.velocity.y = comboDigit.velocity.y - math.random(130,150)
      table.insert(self.comboSprites,comboDigit)
      Tween.create(0.2, comboDigit, { alpha = 0.0 }, "linear", nil, 0.8)
    end
  end
end

return DefaultHUD
