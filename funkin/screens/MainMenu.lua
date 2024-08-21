---@diagnostic disable: duplicate-set-field

local Label = require("jigw.Label")
local Sprite = require("jigw.Sprite")
local Screen = require("jigw.Screen")
local MainMenu = Screen:extend()
MainMenu.__name = "Main Menu"

local freaky = love.audio.newSource("assets/music/freakyMenu.ogg","stream")

function MainMenu:enter()
  freaky:setVolume(0.1)
  freaky:play()

  local vps = {w=love.graphics.getWidth(),h=love.graphics.getHeight()}

  local bg = Sprite:new(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  bg.color[4] = 0.3
  self:add(bg)

  local blah = Label:new(5,vps.h*0.96,"v"..gameVersion, 20)
  self:add(blah)
end

function MainMenu:clear()
  if freaky then
    freaky:stop()
    --freaky:release()
  end
  Screen:clear()
end

return MainMenu
