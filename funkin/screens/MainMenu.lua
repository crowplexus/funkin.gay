---@diagnostic disable: duplicate-set-field

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local AnimatedSprite = require("jigw.AnimatedSprite")
local Screen = require("jigw.Screen")
local MainMenu = Screen:extend()
MainMenu.__name = "Main Menu"

local selected = 1
local options = {"storymode","freeplay","credits","options"}
local freakybob = love.audio.newSource("assets/music/freakyMenu.ogg","stream")
local buttons = {}

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
    spriteButton:screenCentre("X")
    self:add(spriteButton)
    table.insert(buttons,spriteButton)
    if i == selected then spriteButton:playAnimation("selected") end
  end

  local blah = Label:new(5,vph*0.96,"v"..gameVersion, 20)
  blah.position.z = -1
  blah.strokeSize = 1.5
  self:add(blah)

  freakybob:setVolume(0.1)
  freakybob:play()

  self:sortDrawZ()
end

function MainMenu:keypressed(x)
  local oldS = selected
  if x == "up" then selected = Utils.wrap(selected - 1, 1, #buttons) end
  if x == "down" then selected = Utils.wrap(selected + 1, 1, #buttons) end
  if selected ~= oldS then
    print(oldS)
    print(selected)
    buttons[oldS]:playAnimation("idle")
    buttons[selected]:playAnimation("selected")
    buttons[selected]:screenCentre("X")
  end
end

function MainMenu:clear()
  if freakybob then
    freakybob:stop()
    --freakybob:release()
  end
  Screen:clear()
end

return MainMenu
