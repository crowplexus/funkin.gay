---@diagnostic disable: duplicate-set-field

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local AnimatedSprite = require("jigw.AnimatedSprite")
local Screen = require("jigw.Screen")
local MainMenu = Screen:extend()
MainMenu.__name = "Main Menu"

local menuSounds = {
  confirm = love.audio.newSource("assets/audio/sfx/confirmMenu.ogg","static"),
  scroll = love.audio.newSource("assets/audio/sfx/scrollMenu.ogg","static"),
  cancel = love.audio.newSource("assets/audio/sfx/cancelMenu.ogg","static"),
}
local bgMusic = love.audio.newSource("assets/audio/bgm/freakyMenu.ogg","stream")
local buttons = {}

local selected = 1
local options = {"storymode","freeplay","credits","options"}

function MainMenu:new()
  MainMenu.super.new()
  MainMenu.buttons = {}
  MainMenu.selected = 1
  return self
end

function MainMenu:enter()
  local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  bg.position.z = 0
  self:add(bg)

  local nightmarevision = require("jigw.util.AtlasSpriteHelper")
  for i,name in ipairs(options) do
    local path = "assets/images/menu/main/"..name
    local spriteButton = AnimatedSprite(0, (160 * i) - 80, love.graphics.newImage(path..".png"))
    local bttnAnim = nightmarevision:getAnimationListSparrow(path..".xml")
    spriteButton:addAnimationTransform("selected", bttnAnim[name.." selected"].frames, 24)
    spriteButton:addAnimationTransform("idle", bttnAnim[name.." idle"].frames, 24)
    spriteButton:playAnimation("idle", true)
    spriteButton:centerPosition("X")
    self:add(spriteButton)
    table.insert(buttons,spriteButton)
    if i == selected then spriteButton:playAnimation("selected") end
  end

  local blah = Label:new(5,vph*0.97,"Funkin' Kiskadee v"..gameVersion, 20)
  blah.strokeSize = 1.25
  blah.position.z = -1
  self:add(blah)

  bgMusic:setVolume(0.5)
  bgMusic:play()

  self:sortDrawZ()
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
  if x == "d" then
    Utils.match(selected,{
      [0] = function() ScreenManager:switchScreen("funkin.screens.MainMenu") end,
      [1] = function() ScreenManager:switchScreen("funkin.screens.MainMenu") end,
      [2] = function() ScreenManager:switchScreen("funkin.screens.MainMenu") end,
      [3] = function() ScreenManager:switchScreen("funkin.screens.MainMenu") end,
    })
  end
end

--[[ function MainMenu:update(dt)
    MainMenu.super.update(MainMenu, dt)
    
    for i = 1, #buttons do
        buttons[i].rotation = buttons[i].rotation + dt;
    end

end ]]


function MainMenu:clear()
  MainMenu.super.clear()
  if bgMusic then
    bgMusic:stop()
  end
end

return MainMenu
