---@diagnostic disable: duplicate-set-field
local FreeplayMenu = Screen:extend("FreeplayMenu")
function FreeplayMenu:__tostring()
	return "Freeplay Menu"
end

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")

local menuSounds = {
	confirm = Paths.getPath("ui/menu/sfx/confirmMenu.ogg"),
	scroll = Paths.getPath("ui/menu/sfx/scrollMenu.ogg"),
	cancel = Paths.getPath("ui/menu/sfx/cancelMenu.ogg"),
}

local songList = {
	{
		name = "Test",
		folder = "test",
		icon = "ui/icons/bf",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() }, -- {Background Colour, Capsule Colour}
	},
}
local selected = 1
local background = nil
local songTable = {}

function FreeplayMenu:new()
	FreeplayMenu.super.new()
	return self
end

function FreeplayMenu:enter()
	if not Sound.isMusicPlaying() then
		Sound.playMusic(Paths.getPath("ui/menu/bgm/freakyMenu.ogg"), "stream", 0.08, true) -- 80% volume
	end
	--local vpw, vph = love.graphics.getDimensions()

	local assetFolder = Paths.getPath("data/freeplaySonglist")
	local customSongList = require(string.gsub(assetFolder, "/", "."))
	if type(customSongList) == "table" then
		songList = customSongList
		print("loaded custom songs in freeplay")
	end

	background = Sprite(0, 0, Paths.getImage("ui/menu/menuDesat"))
	background.color = songList[1].colors[1]
	self:add(background)

	for i = 1, #songList do
		local song = songList[i]
		local songLabel = Label(0, 5 + (60 * i), song.name, 64)
		songLabel:changeFontFromPath(Paths.getPath("ui/fonts/vcr.ttf"))
		songLabel.alpha = i == selected and 1.0 or 0.6
		songLabel.strokeSize = 1.5
		table.insert(songTable, i, songLabel)
		self:add(songLabel)

		local iconX, iconY = songLabel.position.x + songLabel:getWidth() + 5, songLabel.position.y
		--print(" dad engine ")
		local songIcon = Sprite(0, 0, Paths.getImage(song.icon), 2, 1)
		songIcon.hframes = 2
		songIcon.scale.x, songIcon.scale.y = 0.6, 0.6
		songIcon.position.x, songIcon.position.y = iconX, iconY - 5
		--print(" h frmeams "..songIcon.hframes)
		self:add(songIcon)
	end
end

function FreeplayMenu:keypressed(x)
	local oldS = selected
	local sMult = InputManager.getActionAxis("ui_down", "ui_up")

	if sMult ~= 0 then
		selected = Utils.wrap(selected + sMult, 1, #songTable)
	end
	if selected ~= oldS then
		songTable[oldS].alpha = 0.6
		songTable[selected].alpha = 1.0
		Sound.playSound(menuSounds.scroll, "static", 0.7)
	end

	if background ~= nil and background.color ~= songList[selected].colors[1] then
		Tween.cancelTweensIn(background)
		Tween.create(0.5, background, { color = songList[selected].colors[1] })
		--background.color = songList[selected].colors[1] or Color.WHITE()
	end

	if InputManager.getJustPressed("ui_accept", true) then
		local switch = true --- change this to a filesystem check then error when needed
		if not switch then
			Sound.playSound(menuSounds.cancel, "static", 0.7)
		else
			Sound.stopMusic(true)
			ScreenManager:switchScreen("funkin.screens.Gameplay", { "test", "test" })
		end
	end
end

return FreeplayMenu
