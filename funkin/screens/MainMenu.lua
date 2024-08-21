---@diagnostic disable: duplicate-set-field

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local Screen = require("jigw.Screen")
local MainMenu = Utils:extend(Screen)
MainMenu.__name = "Main Menu" -- for debugging.

local freaky = love.audio.newSource("assets/music/freakyMenu.ogg","stream")
local testLabel

function MainMenu:enter()
  freaky:setVolume(0.1)
  freaky:play()

  local vps = {w=love.graphics.getWidth(),h=love.graphics.getHeight()}
  testLabel = Label:new(vps.w*0.5,vps.h*0.5,"Keyboard Test\nPushed nothing",32)

  local bg = Sprite:new(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  bg.color[4] = 0.3
  Screen:add(bg)
  Screen:add(testLabel)
end

function MainMenu:clear()
  if freaky then
    freaky:stop()
    --freaky:release()
  end
  Screen:clear()
end

function MainMenu:keypressed(key)
  testLabel.text = "Keyboard Test\nPushed key "..key
end

return MainMenu
