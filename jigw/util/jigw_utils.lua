return {
  --- @param x number number of bytes to format.
  --- @param digits? number number of digits on the returning string, defaults to 2.
  --- @return string
  format_bytes = function(x, digits)
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
  -- helper function for inheriting classes.
  --- @param target table   Class that will extend the specified ones,
  --- @param parent table      Classes to clone methods and properties from.
  extend = function(target, parent)
    local child_class = {}
    for i,v in pairs(parent) do
      child_class[i] = v
    end
    return child_class
  end,
  --- to draw text with a stroke behind it.
  --- @param text string
  --- @param x number
  --- @param y number
  --- @param text_colour table<number>
  --- @param stroke_colour table<number>
  --- @param font love.graphics.Font
  --- @param stroke_size number
  draw_text_with_stroke = function(text,x,y,text_colour,stroke_colour,font,stroke_size)
    if not stroke_size then stroke_size = 1 end
    if not text_colour then text_colour = {1,1,1,1} end
    if not stroke_colour then stroke_colour = {0,0,0,1} end
    if not font then font = love.graphics.getFont() end
    if not x then x = 0 end
    if not y then y = 0 end

    local text = love.graphics.newText(font,text)
    local offset = -stroke_size
    love.graphics.setColor(stroke_colour)
    for i = 1,2 do
      love.graphics.draw(text,stroke_size,stroke_size+offset)
      love.graphics.draw(text,stroke_size + offset,stroke_size)
      love.graphics.draw(text,stroke_size - offset,stroke_size + offset)
      love.graphics.draw(text,stroke_size + offset,stroke_size - offset)
      offset = -offset
    end
    love.graphics.setColor(text_colour)
    love.graphics.draw(text,stroke_size,stroke_size)
    love.graphics.setColor(1,1,1,1)
    text:release() -- free memory
  end,
}
