local GameplayHUD = Classic:extend("GameplayHUD")
local PopupSprite = require("funkin.gameplay.hud.PopupSprite")

local function getScoreText(tally)
	local scrRep = tally and Utils.thousandSep(tally.score) or "0"
	local accRep = tally and string.format("%.2f", tally:getAccuracy()) or "0.00"
	local missRep = tally and tally.misses or "0"
	local clearRep = tally and tally.clear or "(NOPLAY) "
	local gradeRep = tally and tally:getCurrentGrade() or ""
	if _G.PROJECT.allowLocales == true then
		return Translator.getString("scoreText", "Gameplay", { scrRep, accRep, clearRep, gradeRep, missRep})
	--return Translator.getString("scoreText","Gameplay",{scrRep,accRep,clearRep,gradeRep, missRep})
	else
		return "Score:" .. scrRep
		--return "Score: "..scrRep .." | Accuracy: "..accRep.."%" .." | "..clearRep..gradeRep
	end
end

function GameplayHUD:construct()
	self.super.construct(self)

	self.scoreText = nil --- @class jigw.objects.Label
	self.judgementCounter = nil --- @class jigw.objects.Label
	self.comboSprites = {} --- @class table<funkin.gameplay.hud.PopupSprite>

	local Label = require("jigw.objects.Label")
	local ProgressShape = require("jigw.objects.ProgressShape")
	local _, vph = love.graphics.getDimensions()

	local downscroll = false
	local healthBarY = downscroll and vph * 0.1 or vph * 0.9

	self.healthBar = ProgressShape(0, healthBarY, 590, 10)
	self.healthBar.colors = { Color.rgb(255, 0, 0), Color.rgb(102, 255, 51) }
	self.healthBar.percentage = 50 -- center the primary rectangle in the bar
	self.healthBar.fillMode = ProgressFill.RTL -- LTR, RTL, BTT, TTB
	self.healthBar:centerPosition(Axis.X)

	self.scoreText = Label(0, healthBarY + self.healthBar:getHeight() + 15, getScoreText(), 16)
	local posX = self.healthBar.position.x + self.healthBar:getWidth()
	self.scoreText.position.x = posX - self.scoreText:getWidth() - 150
	self.scoreText:changeFontFromPath(Paths.getPath("ui/fonts/vcr.ttf"))
	self.scoreText.strokeSize = 1.0
end

function GameplayHUD:update(dt)
	if self.comboSprites and #self.comboSprites ~= 0 then
		for i = 1, #self.comboSprites do
			local judge = self.comboSprites[i]
			if judge and judge.update then
				judge:update(dt)
				if judge.alpha <= 0.0 then
					judge:dispose()
					table.remove(self.comboSprites, i)
				end
			end
		end
	end
end

function GameplayHUD:draw()
	-- TODO: better way to draw here??? idk
	if self.healthBar and self.healthBar.draw then
		self.healthBar:draw()
	end
	if self.scoreText and self.scoreText.draw then
		self.scoreText:draw()
	end
	if self.judgementCounter and self.judgementCounter.draw then
		self.judgementCounter:draw()
	end
	if self.comboSprites and #self.comboSprites ~= 0 then
		for i = 1, #self.comboSprites do
			local judge = self.comboSprites[i]
			if judge and judge.draw then
				judge:draw()
			end
		end
	end
	--print(shit and "pong" or "ping")
end

function GameplayHUD:displayJudgement(name, offestx, offsety)
	local tex = Paths.getImage("play/scoring/" .. name)
	if tex == nil then
		return
	end
	local judgement = PopupSprite(0, 0, tex)
	if judgement then
		judgement:centerPosition(Axis.XY)
		judgement.position.x = judgement.position.x + (offsetx or 0)
		judgement.position.y = judgement.position.y + (offsety or 0)
		judgement.moving = true
		judgement.scale.x = 0.65
		judgement.scale.y = 0.65
		judgement.acceleration.y = 550
		judgement.velocity.y = judgement.velocity.y - math.random(140, 175)
		judgement.velocity.x = judgement.velocity.x - math.random(0, 10)
		table.insert(self.comboSprites, judgement)

		Tween.create(0.2, judgement, { alpha = 0.0 }, "linear", nil, 0.5)
	end
end

function GameplayHUD:displayCombo(comboCount)
	assert(comboCount, "comboCount value in displayCombo function must be a number!")
	comboCount = math.round(comboCount)
	local comboTable = string.split(tostring(comboCount), "")
	local xOff = #comboTable - 3

	for i = 1, #comboTable do
		local digit = comboTable[i]
		local tex = Paths.getImage("play/scoring/num" .. digit)
		if tex == nil then
			return
		end
		local comboDigit = PopupSprite(0, 0, tex)
		if comboDigit then
			comboDigit.moving = true
			comboDigit.scale.x = 0.45
			comboDigit.scale.y = 0.45

			comboDigit:centerPosition(Axis.XY)

			local offset = ((90 * comboDigit.scale.x) * (i - xOff)) - 60
			comboDigit.position.x = comboDigit.position.x + offset
			comboDigit.position.y = (comboDigit.position.y + comboDigit:getHeight()) - 30

			comboDigit.velocity.x = math.random(-5, 5)
			comboDigit.acceleration.y = math.random(250, 300)
			comboDigit.velocity.y = comboDigit.velocity.y - math.random(130, 150)
			table.insert(self.comboSprites, comboDigit)
			Tween.create(0.2, comboDigit, { alpha = 0.0 }, "linear", nil, 0.8)
		end
	end
end

return GameplayHUD
