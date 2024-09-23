local Screen = Object:extend() --- @class Screen
function Screen:__tostring() return "Screen" end

function Screen:new()
  Screen.objects = {}
  return Screen
end

function Screen:enter() end
function Screen:update(dt)
  for i=1, #self.objects do
    local v = self.objects[i]
    if v ~= nil and v.update then v:update(dt) end
  end
end
function Screen:keypressed(key) end
function Screen:keyreleased(key) end
function Screen:draw()
  for i,v in pairs(self.objects) do
    --local v = self.objects[i]
    if v and v.draw then v:draw() end
  end
end

function Screen:clear()
  local i = #Screen.objects
  while i > 1 do
    local obi = Screen.objects[i]
    if obi ~= nil then
      if obi.dispose then
        obi:dispose()
      elseif obi.release then
        obi:release()
      end
      obi = nil
    end
    table.remove(Screen.objects, i)
    i = i - 1
  end
end

function Screen:add(obj)
  if not self.objects[obj] ~= nil then
    table.insert(self.objects, obj)
  end
end

function Screen:remove(obj)
  for _,v in ipairs(self.objects) do
    if v == obj then table.remove(self.objects,_) end
  end
end

function Screen:sortDrawZ()
  table.sort(self.objects, function(a,b)
    if a and b and a.position.z and b.position.z then
      return Vector3.sortByZ(-1,a,b)
    end
  end)
end

return Screen
