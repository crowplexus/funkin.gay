---@diagnostic disable: duplicate-set-field
local MainMenu = Screen:extend("MainMenu")

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")
local AnimatedSprite = require("jigw.objects.AnimatedSprite")

local menuSounds = {
	confirm = Paths.getPath("ui/menu/sfx/confirmMenu.ogg"),
	scroll = Paths.getPath("ui/menu/sfx/scrollMenu.ogg"),
	cancel = Paths.getPath("ui/menu/sfx/cancelMenu.ogg"),
}
local options = { "storymode", "freeplay", "options", "credits" }
local optionFuncs = {
	-- [positionInMenu] = function() end
	--[1] = function() ScreenManager:switchScreen("funkin.screens.StoryMenu") end,
	[2] = function()
		ScreenManager:switchScreen("funkin.screens.FreeplayMenu")
	end,
	--[3] = function() ScreenManager:switchScreen("funkin.screens.OptionsMenu") end,
	--[4] = function() ScreenManager:switchScreen("funkin.screens.CreditsMenu") end,
}

local buttons = {}
local selected = 1

function MainMenu:enter()
	if not Sound.isMusicPlaying() then
		Sound.playMusic(Paths.getPath("ui/menu/bgm/freakyMenu.ogg"), "stream", 0.08, true) -- 80% volume
	end
	local vpw, vph = love.graphics.getDimensions()

	local bg = Sprite(0, 0, Paths.getImage("ui/menu/menuBG"))
	self:add(bg)

	for i, name in ipairs(options) do
		local path = Paths.getPath("ui/menu/main/" .. name)
		local spriteButton = AnimatedSprite(0, (160 * i) - 30)
		spriteButton:loadAtlas(path, {
			{ "idle", name .. " idle", 24 },
			{ "selected", name .. " selected", 24 },
		})
		spriteButton:playAnimation("idle", true)
		spriteButton:centerPosition(Axis.X)
		self:add(spriteButton)
		table.insert(buttons, spriteButton)
		if i == selected then
			spriteButton:playAnimation("selected")
		end
	end

	local versionText = Label(5, 0, "Funkin' Kiskadee v" .. _G.GAME_VER, 20)
	versionText:changeFontFromPath(Paths.getPath("ui/fonts/vcr.ttf"))
	versionText.position.y = (vph - versionText.size.y) - 25 -- i think that's the original pos idk
	versionText.strokeSize = 1.5
	self:add(versionText)
end

function MainMenu:keypressed()
	local oldS = selected
	local sMult = InputManager.getActionAxis("ui_down", "ui_up")

	selected = Utils.wrap(selected + sMult, 1, #buttons)

	if selected ~= oldS then
		buttons[oldS]:playAnimation("idle")
		buttons[selected]:playAnimation("selected")
		Sound.playSound(menuSounds.scroll, "static", 0.7)
	end
	if InputManager.getJustPressed("ui_accept") then
		if optionFuncs[selected] then
			Utils.match(selected, optionFuncs)
		else -- error handling
			Sound.playSound(menuSounds.cancel, "static", 0.7)
			print("option " .. selected .. " doesn't really do anything!")
		end
	end
end

return MainMenu
