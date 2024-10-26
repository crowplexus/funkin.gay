---@diagnostic disable: duplicate-set-field
local FreeplayMenu = Screen:extend()
function FreeplayMenu:__tostring() return "Freeplay Menu" end

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")

local menuSounds = {
  confirm = "assets/ui/menu/sfx/confirmMenu.ogg",
  scroll  = "assets/ui/menu/sfx/scrollMenu.ogg",
  cancel  = "assets/ui/menu/sfx/cancelMenu.ogg",
}

local testSongs = {"tutorial","bopeebo","fresh","dadbattle"}
local songTable = {}
local selected = 1

function FreeplayMenu:new()
  FreeplayMenu.super.new()
  FreeplayMenu.songTable = {}
  FreeplayMenu.selected = 1
  return self
end

function FreeplayMenu:enter()
	if not Sound.isMusicPlaying() then
  	Sound.playMusic("assets/ui/menu/bgm/freakyMenu.ogg","stream",0.08,true) -- 80% volume
	end
  --local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/ui/menu/menuDesat.png"))
	bg.color = Color.rgb(227, 125, 255)
  self:add(bg)

	for i=1, #testSongs do
		local songLabel = Label(0,5+(60*i),testSongs[i],64)
		songLabel:changeFontFromPath("assets/ui/fonts/vcr.ttf")
		songLabel.alpha = i == selected and 1.0 or 0.6
		songLabel.strokeSize = 1.5
		table.insert(songTable,i,songLabel)
		self:add(songLabel)
	end
end

function FreeplayMenu:keypressed(x)
  local oldS = selected
	local sMult = InputManager.getActionAxis("ui_down", "ui_up")

  if sMult ~= 0 then selected = Utils.wrap(selected + sMult, 1, #songTable) end
  if selected ~= oldS then
		songTable[oldS].alpha = 0.6
		songTable[selected].alpha = 1.0
		Sound.playSound(menuSounds.scroll,"static",0.7)
  end
  if InputManager.getJustPressed("ui_accept",true) then
		local switch = true --- change this to a filesystem check then error when needed
		if not switch then
			Sound.playSound(menuSounds.cancel,"static",0.7)
		else
			Sound.stopMusic(true)
			ScreenManager:switchScreen("funkin.screens.Gameplay")
		end
  end
end

return FreeplayMenu
