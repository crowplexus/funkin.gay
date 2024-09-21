---@diagnostic disable: duplicate-set-field
local MainMenu = require("jigw.Screen"):extend()
function MainMenu:__tostring() return "Main Menu" end

-- "imports" ig lol

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local AnimatedSprite = require("jigw.AnimatedSprite")

local menuSounds = {
  confirm = love.audio.newSource("assets/audio/sfx/confirmMenu.ogg","static"),
  scroll = love.audio.newSource("assets/audio/sfx/scrollMenu.ogg","static"),
  cancel = love.audio.newSource("assets/audio/sfx/cancelMenu.ogg","static"),
}
local bgMusic = love.audio.newSource("assets/audio/bgm/freakyMenu.ogg","stream")
local options = {"storymode","freeplay","options","credits"}
local optionFuncs = {
  -- [positionInMenu] = function() end
  [1] = function() ScreenManager:switchScreen("funkin.screens.StoryMenu") end,
  [2] = function() ScreenManager:switchScreen("funkin.screens.FreeplayMenu") end,
  [3] = function() ScreenManager:switchScreen("funkin.screens.OptionsMenu") end,
  [4] = function() ScreenManager:switchScreen("funkin.screens.CreditsMenu") end,
  -- functions may do anything they need to, other than switching screens
}

-- hud test --

local judgmentCounter
local scoreText

-- -- -- -- --

local buttons = {}
local selected = 1

function MainMenu:new()
  MainMenu.super.new()
  MainMenu.buttons = {}
  MainMenu.selected = 1
  return self
end

function MainMenu:enter()
  local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  self:add(bg)

  bgMusic:setVolume(0.05)
  bgMusic:play()

  -- TODO: make this easier, something like `spriteButton:loadAtlas(path,type)` or idk
  local atlasHelper = require("jigw.util.AtlasSpriteHelper")
  for i,name in ipairs(options) do
    local path = "assets/images/menu/main/"..name
    local spriteButton = AnimatedSprite(0, (160 * i) - 30, love.graphics.newImage(path..".png"))
    local bttnAnim = atlasHelper:getAnimationListSparrow(path..".xml")
    spriteButton:addAnimationTransform("selected", bttnAnim[name.." selected"].frames, 24)
    spriteButton:addAnimationTransform("idle", bttnAnim[name.." idle"].frames, 24)
    spriteButton:playAnimation("idle", true)
    spriteButton:centerPosition("X")
    self:add(spriteButton)
    table.insert(buttons,spriteButton)
    if i == selected then spriteButton:playAnimation("selected") end
  end

  local versionText = Label(5,0,"Funkin' Kiskadee v"..gameVersion, 20)
  versionText.position.y = (vph - versionText.size.y) - 5 -- i think that's the original pos idk
  versionText.strokeSize = 1.5
  self:add(versionText)

  -- i swear to god i just did this for testing
  -- please neb or anyone else just move this to a class or something LOL

  local scoreText = Label(0,0,"Score: "..Utils.thousandSep(1000).." | Accuracy: 0% | (ClearFlag) Grade",20)
  scoreText:centerPosition("sex") -- funny how that works huh.
  scoreText.position.y = (vph - scoreText.size.y) - 15
  scoreText.strokeSize = 1.25
  self:add(scoreText)

  -- make this better prob? idk !!!!

  judgmentCounter = Label(5,0,getJudges(),20)
  judgmentCounter.position.y = (vph-judgmentCounter.size.y)*0.5
  judgmentCounter.strokeSize = 2
  self:add(judgmentCounter)
  --judgmentCounter.text = getJudges() -- doesn't really work cus setters are broken
end

function getJudges()
  local str = ""
  local judges = {"Epics","Sicks","Goods","Bads","Shits","Misses"}
  local counts = {0,      0,      0,      0,      0,      0}
  for i=1,#judges do str = str..judges[i]..": "..counts[i].."\n" end
  return str
end

function MainMenu:keypressed(x)
  local oldS = selected
  if x == "up" then selected = Utils.wrap(selected - 1, 1, #buttons) end
  if x == "down" then selected = Utils.wrap(selected + 1, 1, #buttons) end
  if selected ~= oldS then
    buttons[oldS]:playAnimation("idle")
    buttons[selected]:playAnimation("selected")
    buttons[selected]:centerPosition("X")
    love.audio.stop(menuSounds.scroll)
    love.audio.play(menuSounds.scroll)
  end
  if x == "return" then
    if optionFuncs[selected] then
      Utils.match(selected,optionFuncs)
    else -- error handling
      love.audio.stop(menuSounds.cancel)
      love.audio.play(menuSounds.cancel)
      print("this option doesn't really do anything! - selected "..selected)
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
  if bgMusic then bgMusic:stop() end
  MainMenu.super.clear()
end

return MainMenu
