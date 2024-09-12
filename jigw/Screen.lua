local Screen = Object:extend()
Screen.objects = {}
Screen.__name = "Screen"
--Screen.__index = Screen

function Screen:new()
  self.objects = {}
  return self
end

function Screen:enter() end
function Screen:update(dt)
  for i=1, #self.objects do
    local v = self.objects[i]
    if v and v.update then v:update(dt) end
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
  while #self.objects ~= 0 do
    if self.objects[0] and self.objects[0].dispose then
      self.objects[0]:dispose()
      if self.objects[0] ~= nil then
        self.objects[0] = nil
      end
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
    if v == obj then
      table.remove(self.objects,_)
    end
  end
end

function Screen:sortDrawZ()
  -- doesn't work i'll check this later
  --table.sort(self.objects, function(a,b) return Vector3.sortByZ(-1,a,b) end)
end

--return setmetatable(Screen, {__index = Screen})
return Screen
