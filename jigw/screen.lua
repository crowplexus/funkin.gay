local Screen = {
  __name = "Screen",
  objects = {},
}
Screen.__index = Screen

function Screen:enter() end
function Screen:update(dt) end
function Screen:keypressed(key) end
function Screen:keyreleased(key) end
function Screen:draw()
  for _,v in pairs(self.objects) do
    if v and v.draw then v:draw() end
  end
end

function Screen:clear()
  while #self.objects ~= 0 do
    if self.objects[0] and self.objects[0].dispose then
      self.objects[0]:dispose()
    end
    table.remove(self.objects, i)
  end
end

function Screen:add(obj)
  if not self.objects[obj] then
    table.insert(self.objects, obj)
  end
end

function Screen:remove(obj)
  for _,v in ipairs(self.objects) do
    if v == obj then table.remove(self.objects,_) end
  end
end

return setmetatable(Screen, {__index = Screen})
