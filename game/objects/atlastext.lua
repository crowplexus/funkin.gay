--- @class AtlasText
local AtlasText = Class("AtlasText")

--- Creates a new text field with the given text.
--- @param x? number     X position of the text field.
--- @param y? number     Y position of the text field.
--- @param text? string Text to display.
function AtlasText:init(x, y, text)
    self.text = text or ""      --- @type string
    self.visible = true         --- @type boolean
    self.position = Vec2(x, y)  --- @type Vec2
    self.tint = { 1, 1, 1, 1 } --- @type table<number>
    self.alignment = "left"     --- @type "left"|"center"|"right"
    return self
end

function AtlasText:update(_)
end

function AtlasText:draw()
    if #self.text ~= 0 or self.visible then
        love.graphics.push("all")
        if self.tint then love.graphics.setColor(self.tint) end
        love.graphics.draw()
        if self.tint then love.graphics.setColor(1, 1, 1, 1) end
        love.graphics.pop()
    end
end

function AtlasText:set_text(vl)
    if #vl == 0 then
        self.text = vl
        return
    end
    local chars = string.split(vl, "")
    for i = 1, #chars do
        local char = string.gsub(chars[i], "\\n", "\n")
        if char == " " then
            -- offset space
            return
        end
        if char == "\n" then
            -- offset line break
            return
        end

        local letter = nil
    end
end

return AtlasText
