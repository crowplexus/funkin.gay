---@diagnostic disable: duplicate-set-field

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local Screen = require("jigw.Screen")
local MainMenu = Screen:extend()
MainMenu.__name = "Main Menu"

local freakybob = love.audio.newSource("assets/music/freakyMenu.ogg","stream")

function MainMenu:enter()
  local vpw, vph = love.graphics.getDimensions()

  local bg = Sprite:new(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  bg.position.z = 0
  self:add(bg)

  local bf = require("jigw.AnimatedSprite"):new(360,240,love.graphics.newImage("assets/BOYFRIEND.png"))
  local nightmarevision = require("jigw.util.AtlasSpriteHelper"):getAnimationListSparrow("assets/BOYFRIEND.xml")
  bf:addAnimationTransform("idle", nightmarevision["BF idle dance"].frames, 24)
  bf.currentAnimation = "idle"
  self:add(bf)

  local blah = Label:new(5,vph*0.96,"v"..gameVersion, 20)
  blah.position.z = -1
  blah.strokeSize = 1
  self:add(blah)

  freakybob:setVolume(0.1)
  freakybob:play()

  self:sortDrawZ()
end

function MainMenu:clear()
  if freakybob then
    freakybob:stop()
    --freakybob:release()
  end
  Screen:clear()
end

return MainMenu
