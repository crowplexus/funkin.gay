local Screen = Object:extend()
Screen.objects = {}
Screen.__name = "Screen"
--Screen.__index = Screen

function Screen:new()
  Screen.objects = {}
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
  while #Screen.objects ~= 0 do
    local i = 1
    if Screen.objects[i] then
      if Screen.objects[i].dispose then
        Screen.objects[i]:dispose()
      elseif Screen.objects[i].release then
        Screen.objects[I]:release()
      end
      if Screen.objects[i] ~= nil then
        Screen.objects[I] = nil
      end
    end
    table.remove(Screen.objects, i)
  end
end

function Screen:add(obj)
  if not Screen.objects[obj] then
    table.insert(Screen.objects, obj)
  end
end

function Screen:remove(obj)
  for _,v in ipairs(Screen.objects) do
    if v == obj then
      table.remove(Screen.objects,_)
    end
  end
end

function Screen:sortDrawZ()
  -- doesn't work i'll check this later
  --table.sort(Screen.objects, function(a,b) return Vector3.sortByZ(-1,a,b) end)
end

--return setmetatable(Screen, {__index = Screen})
return Screen
