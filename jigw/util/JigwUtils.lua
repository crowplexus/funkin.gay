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

    local nf = type(font) == "string" and love.graphics.newFont(font, 32) or font
    local text = love.graphics.newText(nf,text)
    local offset = -strokeSize
    love.graphics.setColor(strokeColour)
    for i=1,2 do
      love.graphics.draw(text, x + strokeSize,          y + strokeSize + offset)
      love.graphics.draw(text, x + strokeSize + offset, y + strokeSize)
      love.graphics.draw(text, x + strokeSize - offset, y + strokeSize + offset)
      love.graphics.draw(text, x + strokeSize + offset, y + strokeSize - offset)
      offset = -offset
    end
    love.graphics.setColor(textColour)
    love.graphics.draw(text,x + strokeSize,y + strokeSize)
    love.graphics.setColor(1,1,1,1)
    -- free memory
    text:release()
    nf:release()
    text = nil
    nf = nil
  end,

  tablePrint = function(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  "= "
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\r\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\r\n"
      elseif (type(v) == "table") then
        toprint = toprint .. Utils.tablePrint(v, indent + 2) .. ",\r\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
  end
}
