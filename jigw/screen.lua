-- CONFIGURE METATABLE --

local screen = {
  objects = {},
  __name = "Screen",
}
require("jigw.class"):clone(screen,require("jigw.class"))
screen.__index = screen

-- METAMETHODS --

function screen:enter() end
function screen:update(dt) end
function screen:draw() end
function screen:clear() end

function screen:add(obj)
  if not table[obj] then
    table.insert(screen.objects, obj)
  end
end

function screen:remove(obj)
  for _,v in ipairs(screen.objects) do
    if v == obj then table.remove(obj, _) end
  end
end

function screen:__index(table, key)
  return screen[key]
end

return screen