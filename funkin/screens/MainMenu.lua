---@diagnostic disable: duplicate-set-field
local MainMenu = Screen:extend()
function MainMenu:__tostring() return "Main Menu" end

-- "imports" ig lol

local Label = require("jigw.objects.Label")
local Sprite = require("jigw.objects.Sprite")
local AnimatedSprite = require("jigw.objects.AnimatedSprite")

local menuSounds = {
  confirm = "assets/ui/menu/sfx/confirmMenu.ogg",
  scroll  = "assets/ui/menu/sfx/scrollMenu.ogg",
  cancel  = "assets/ui/menu/sfx/cancelMenu.ogg",
}
local options = {"storymode","freeplay","options","credits"}
local optionFuncs = {
  -- [positionInMenu] = function() end
  --[1] = function() ScreenManager:switchScreen("funkin.screens.StoryMenu") end,
  [2] = function() ScreenManager:switchScreen("funkin.screens.FreeplayMenu") end,
  --[3] = function() ScreenManager:switchScreen("funkin.screens.OptionsMenu") end,
  --[4] = function() ScreenManager:switchScreen("funkin.screens.CreditsMenu") end,
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
  if not Sound.isMusicPlaying() then
    Sound.playMusic("assets/ui/menu/bgm/freakyMenu.ogg","stream",0.08,true) -- 80% volume
  end
  local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/ui/menu/menuBG.png"))
  self:add(bg)

  for i,name in ipairs(options) do
    local path = "assets/ui/menu/main/"..name
    local spriteButton = AnimatedSprite(0, (160 * i) - 30)
    spriteButton:loadAtlas(path, {
      {"idle", name.." idle", 24},
      {"selected", name.." selected", 24}
    })
    spriteButton:playAnimation("idle", true)
    spriteButton:centerPosition(Axis.X)
    self:add(spriteButton)
    table.insert(buttons,spriteButton)
    if i == selected then spriteButton:playAnimation("selected") end
  end

  local versionText = Label(5,0,"Funkin' Kiskadee v".._G.GAME_VER, 20)
  versionText:changeFontFromPath("assets/ui/fonts/vcr.ttf")
  versionText.position.y = (vph - versionText.size.y) - 25 -- i think that's the original pos idk
  versionText.strokeSize = 1.5
  self:add(versionText)

  --local ndsp = require("funkin.objects.NoteDisplay")
  --local note = ndsp.generateNote("default",4)
  --self:add(note)
end

function MainMenu:keypressed(x)
  local oldS = selected
  local sMult = InputManager.getActionAxis("ui_down", "ui_up")

  if sMult ~= 0 then selected = Utils.wrap(selected + sMult, 1, #buttons) end
  if selected ~= oldS then
    buttons[oldS]:playAnimation("idle")
    buttons[selected]:playAnimation("selected")
    Sound.playSound(menuSounds.scroll,"static",0.7)
  end
  if InputManager.getJustPressed("ui_accept",true) then
    if optionFuncs[selected] then
      Utils.match(selected,optionFuncs)
    else -- error handling
      Sound.playSound(menuSounds.cancel,"static",0.7)
      print("option "..selected.." doesn't really do anything!")
    end
  end
end

return MainMenu
