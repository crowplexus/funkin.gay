return {
  --- @param x number number of bytes to format.
  --- @param digits? number number of digits on the returning string, defaults to 2.
  --- @return string
  formatBytes = function(x, digits)
      if digits == nil or type(digits) ~= "string" then
          digits = 2
      end
      local units = {"B", "KB", "MB", "GB", "TB", "PB"}
      local unit = 3
      while x >= 1024 and unit < #units do
          x = x / 1024
          unit = unit + 1
      end
      return string.format("%."..digits.."f", x)..units[unit]
  end,
  --- fake match/switch for lua
  match = function(prop, pat)
    if pat[prop] ~= nil then pat[prop]()
    elseif pat.default ~= nil then pat.default() end
  end,
  --- helper function for inheriting classes.
  --- @param target table   Class that will extend the specified ones,
  --- @param parent table      Classes to clone methods and properties from.
  extend = function(target, parent)
    local child_class = target or {}
    for i,v in pairs(parent or {}) do
      child_class[i] = v
    end
    return child_class
  end,
  --- to draw text with a stroke behind it.
  --- @param text string
  --- @param x number
  --- @param y number
  --- @param textColour table<number>
  --- @param strokeColour table<number>
  --- @param font love.graphics.Font
  --- @param strokeSize number
  drawTextWithStroke = function(text,x,y,textColour,strokeColour,font,strokeSize)
    if not strokeSize then strokeSize = 1 end
    if not textColour then textColour = {1,1,1,1} end
    if not strokeColour then strokeColour = {0,0,0,1} end
    if not font then font = love.graphics.getFont() end
    if not x then x = 0 end
    if not y then y = 0 end

    local text = love.graphics.newText(font,text)
    local offset = -strokeSize
    love.graphics.setColor(strokeColour)
    for i = 1,2 do
      love.graphics.draw(text,strokeSize,strokeSize+offset)
      love.graphics.draw(text,strokeSize + offset,strokeSize)
      love.graphics.draw(text,strokeSize - offset,strokeSize + offset)
      love.graphics.draw(text,strokeSize + offset,strokeSize - offset)
      offset = -offset
    end
    love.graphics.setColor(textColour)
    love.graphics.draw(text,strokeSize,strokeSize)
    love.graphics.setColor(1,1,1,1)
    text:release() -- free memory
  end,
}
