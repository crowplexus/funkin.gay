---@diagnostic disable: duplicate-set-field

local label = require("jigw.label")
local sprite = require("jigw.sprite")
local screen = require("jigw.screen")

local freaky = love.audio.newSource("assets/music/freakyMenu.ogg","stream")
local test_label

local main_menu = Utils:extend(screen)
main_menu.__name = "Main Menu" -- for debugging.

function main_menu:enter()
  freaky:setVolume(0.1)
  freaky:play()

  local vps = {w=love.graphics.getWidth(),h=love.graphics.getHeight()}
  test_label = label:new(vps.w*0.5,vps.h*0.5,"Keyboard Test\nPushed nothing",32)
  local bg = sprite:new(0,0,love.graphics.newImage("assets/images/backgrounds/menu/menuBG.png"))
  bg.color[4] = 0.3
  main_menu:add(bg)
  main_menu:add(test_label)
end

function main_menu:clear()
  if freaky then
    freaky:stop()
    --freaky:release()
  end
  screen:clear()
end

function main_menu:keypressed(key)
  test_label.text = "Keyboard Test\nPushed key "..key
end

return main_menu
