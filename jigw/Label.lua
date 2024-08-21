local function buildLabel(sel)
	sel.text = nil
	sel.fontSize = 14
	sel.fontPath = "assets/fonts/vcr.ttf"
	sel.position = Point2(0,0)
	sel.size = Point2(0,0)
	sel.scale = Point2(1,1)
	sel.strokeSize = 0
	sel.strokeColour = Colour.rgba(0,0,0,1)
	sel.colour = Colour.rgba(1,1,1,1)
	sel.visible = true
	sel.textWidth = 0
	sel.textHeight = 0
	sel.rotation = 0
	sel.alpha = 1.0
	return sel
end

local Label = Object:extend()
buildLabel(Label)

function Label:__tostring()
	return "Label"
end

local function _recreateFont(self)
	if self._renderFont then self._renderFont:release() end
	self._renderFont = love.graphics.newFont(self.fontPath, self.fontSize, "none")
end

local function _recreateText(self)
	if self._renderText then self._renderText:release() end
	self._renderText = love.graphics.newText(self._renderFont or love.graphics.getFont(),self.text)
	self.size.x = self._renderText:getWidth()
	self.size.y = self._renderText:getHeight()
end

local function _isFontPath(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

--- Function to draw a label's text field with a stroke below it.
--- @param t love.graphics.Text Text object.
--- @param c table<number> Text colour.
--- @param sc table<number> Text stroke colour.
--- @param x number Text X position.
--- @param y number Text Y position.
--- @param r number Text rotation.
--- @param sz number Text stroke size.
--- @param sx number X value for text scale.
--- @param sy number Y value for text scale.
local function _drawWithStroke(t,c,sc,x,y,r,sz,sx,sy)
	local offset = -sz
  love.graphics.setColor(sc)
  for i = 1,2 do
    love.graphics.draw(t,x + sz,y + sz + offset,r,sx,sy)
    love.graphics.draw(t,x + sz + offset,y + sz,r,sx,sy)
    love.graphics.draw(t,x + sz - offset,y + sz + offset,r,sx,sy)
    love.graphics.draw(t,x + sz + offset,y + sz - offset,r,sx,sy)
    offset = -offset
  end
  love.graphics.setColor(c)
  love.graphics.draw(t,x + sz,y + sz,r,sx,sy)
  love.graphics.setColor(1,1,1,1)
end

function Label:new(x,y,text,size)
	self.position = Point2(x,y)
	self.text = text or nil
	self.fontSize = size or 14
	self._renderFont = nil
	self._renderText = nil
	self:changeFontSize(size, true)
	return self
end

function Label:dispose()
	self._renderFont:release()
	resetVars()
end

function Label:draw()
	if self and self:has_any_text() and self.visible and self.colour[4] > 0.0 then
		-- TODO: use printf for alignments
		if self.strokeSize > 0 then
			_drawWithStroke(
				self._renderText,self.colour,self.strokeColour,
				self.position.x,self.position.y,self.rotation,self.strokeSize,
				self.scale.x or 1.0, self.scale.y or 1.0)
		else
			love.graphics.setColor(self.colour)
			love.graphics.draw(self._renderText,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
			love.graphics.setColor(1,1,1,1)
		end
	end
end

function Label:has_any_text()
	return type(self.text) == "string" and string.len(self.text) ~= 0
end

function Label:changeFont(path)
	local fi = love.filesystem.getInfo(path)
	if _isFontPath(path) and fi and fi.size and self.fontPath ~= path then
		self.fontPath = path
		_recreateFont(self)
		if self._renderText == nil then _recreateText(self)
		else self._renderText.setFont(self._renderFont) end
	end
end

function Label:changeFontSize(newSize, force)
	if force == false then
		if type(newSize) ~= "number" or newSize == self.fontSize then
			return
		end
	end
	self.fontSize = newSize
	_recreateFont(self)
	_recreateText(self)
end

--#region Getters and Setters
function Label:get_alpha() return rawget(self,self.colour[4]) end
function Label:set_alpha(vl) return rawset(self,self.colour[4],vl) end
--#endregion

function Label:__index(idx)
  -- custom get variable functionality
  return rawget(self,"get_"..idx) and rawget(self,"get_"..idx)() or rawget(self,idx)
end

function Label:__newindex(idx,vl)
  -- custom set variable functionality
  return rawget(self,"set_"..idx) and rawget(self,"set_"..idx)(self,vl) or rawset(self,idx,vl)
end

return Label
