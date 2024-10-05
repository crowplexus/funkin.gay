---@diagnostic disable: duplicate-set-field
local FreeplayMenu = Screen:extend()
function FreeplayMenu:__tostring() return "Freeplay Menu" end

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")

local menuSounds = {
  confirm = "assets/audio/sfx/confirmMenu.ogg",
  scroll  = "assets/audio/sfx/scrollMenu.ogg",
  cancel  = "assets/audio/sfx/cancelMenu.ogg",
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
  	Sound.playMusic("assets/audio/bgm/freakyMenu.ogg","stream",0.08,true) -- 80% volume
	end
  --local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/images/menu/menuDesat.png"))
	bg.color = Color.rgb(227, 125, 255)
  self:add(bg)

	for i=1, #testSongs do
		local songLabel = Label(0,5+(60*i),testSongs[i],64)
		songLabel.scale.x = i == selected and 1.0 or 0.6
		songLabel.strokeSize = 1.5
		table.insert(songTable,i,songLabel)
		self:add(songLabel)
	end
end

function FreeplayMenu:keypressed(x)
  local oldS = selected
	local sMult = x == "up" and -1 or x == "down" and 1 or 0
  if sMult ~= 0 then selected = Utils.wrap(selected + sMult, 1, #songTable) end
  if selected ~= oldS then
		songTable[oldS].scale.x = 0.6
		songTable[selected].scale.x = 1.0
		Sound.playSound(menuSounds.scroll,"static",0.7)
  end
  if x == "return" then
		local switch = true --- change this to a filesystem check then error when needed
		if not switch then
			Sound.playSound(menuSounds.cancel,"static",0.7)
		else
			Sound.stopMusic(true)
			ScreenHandler:switchScreen("funkin.screens.Gameplay")
		end
  end
end

return FreeplayMenu
