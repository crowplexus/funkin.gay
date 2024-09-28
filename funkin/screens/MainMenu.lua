---@diagnostic disable: duplicate-set-field
local MainMenu = require("jigw.Screen"):extend()
function MainMenu:__tostring() return "Main Menu" end

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")
local AnimatedSprite = require("jigw.objects.AnimatedSprite")

local menuSounds = {
  confirm = "assets/audio/sfx/confirmMenu.ogg",
  scroll  = "assets/audio/sfx/scrollMenu.ogg",
  cancel  = "assets/audio/sfx/cancelMenu.ogg",
}
local options = {"storymode","freeplay","options","credits"}
local optionFuncs = {
  -- [positionInMenu] = function() end
  --[1] = function() ScreenHandler:switchScreen("funkin.screens.StoryMenu") end,
  --[2] = function() ScreenHandler:switchScreen("funkin.screens.FreeplayMenu") end,
  --[3] = function() ScreenHandler:switchScreen("funkin.screens.OptionsMenu") end,
  --[4] = function() ScreenHandler:switchScreen("funkin.screens.CreditsMenu") end,
  [1] = function() ScreenHandler:switchScreen("funkin.screens.Gameplay") end,
  -- functions may do anything they need to, other than switching screens
}

local buttons = {}
local selected = 1

function MainMenu:new()
  MainMenu.super.new()
  MainMenu.buttons = {}
  MainMenu.selected = 1
  return self
end

function MainMenu:enter()
  Sound.playMusic("assets/audio/bgm/freakyMenu.ogg","stream",0.08,true) -- 80% volume
  local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  self:add(bg)

  -- TODO: make this easier, something like `spriteButton:loadAtlas(path,type)` or idk
  local atlasHelper = require("jigw.util.AtlasSpriteHelper")
  for i,name in ipairs(options) do
    local path = "assets/images/menu/main/"..name
    local spriteButton = AnimatedSprite(0, (160 * i) - 30, love.graphics.newImage(path..".png"))
    local bttnAnim = atlasHelper:getAnimationListSparrow(path..".xml")
    spriteButton:addAnimationTransform("selected", bttnAnim[name.." selected"].frames, 24)
    spriteButton:addAnimationTransform("idle", bttnAnim[name.." idle"].frames, 24)
    spriteButton:playAnimation("idle", true)
    spriteButton:centerPosition(Axis.X)
    self:add(spriteButton)
    table.insert(buttons,spriteButton)
    if i == selected then spriteButton:playAnimation("selected") end
  end

  local versionText = Label(5,0,"Funkin' Kiskadee v".._G.GAME_VER, 20)
  versionText.position.y = (vph - versionText.size.y) - 25 -- i think that's the original pos idk
  versionText.strokeSize = 1.5
  self:add(versionText)
end

function MainMenu:keypressed(x)
  local oldS = selected
  if x == "up" then selected = Utils.wrap(selected - 1, 1, #buttons) end
  if x == "down" then selected = Utils.wrap(selected + 1, 1, #buttons) end
  if selected ~= oldS then
    buttons[oldS]:playAnimation("idle")
    buttons[selected]:playAnimation("selected")
    Sound.playSound(menuSounds.scroll,"static",0.7)
  end
  if x == "return" then
    if optionFuncs[selected] then
      Utils.match(selected,optionFuncs)
    else -- error handling
      Sound.playSound(menuSounds.cancel,"static",0.7)
      print("option "..selected.." doesn't really do anything!")
    end
  end
end

--[[
function MainMenu:update(dt)
    MainMenu.super.update(MainMenu, dt)
    for i = 1, #buttons do
        buttons[i].rotation = buttons[i].rotation + dt;
    end
end
]]

function MainMenu:clear()
  Sound.stopMusic(true) -- this is going to crash. -- it didn't
  MainMenu.super.clear()
end

return MainMenu
