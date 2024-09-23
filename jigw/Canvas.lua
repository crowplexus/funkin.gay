local Canvas = Object:extend() --- @class Canvas
function Canvas:__tostring() return "Canvas" end

function Canvas:new()
  Canvas.objects = {}
  return Canvas
end

function Canvas:enter() end
function Canvas:update(dt)
  for i=1, #self.objects do
    local v = self.objects[i]
    if v ~= nil and v.update then v:update(dt) end
  end
end
function Canvas:keypressed(key) end
function Canvas:keyreleased(key) end
function Canvas:draw()
  for i,v in pairs(self.objects) do
    --local v = self.objects[i]
    if v and v.draw then v:draw() end
  end
end

function Canvas:clear()
  local i = #Canvas.objects
  while i > 1 do
    local obi = Canvas.objects[i]
    if obi ~= nil then
      if obi.dispose then
        obi:dispose()
      elseif obi.release then
        obi:release()
      end
      obi = nil
    end
    table.remove(Canvas.objects, i)
    i = i - 1
  end
end

function Canvas:add(obj)
  if not self.objects[obj] ~= nil then
    table.insert(self.objects, obj)
  end
end

function Canvas:remove(obj)
  for _,v in ipairs(self.objects) do
    if v == obj then table.remove(self.objects,_) end
  end
end

function Canvas:sortDrawZ()
  table.sort(self.objects, function(a,b)
    if a and b and a.position.z and b.position.z then
      return Vector3.sortByZ(-1,a,b)
    end
  end)
end

return Canvas
