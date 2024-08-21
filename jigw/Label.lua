local function buildLabel(sel)
	sel.text = nil
	sel.fontSize = 14
	sel.fontPath = "assets/fonts/vcr.ttf"
	sel.position = Point2(0,0)
	sel.size = Point2(0,0)
	sel.scale = Point2(1,1)
	sel.strokeSize = 1
	sel.strokecolour = Colour.rgba(0,0,0,1)
	sel.colour = Colour.rgba(1,1,1,1)
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
		love.graphics.setColor(self.colour)
		love.graphics.draw(self._renderText,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		love.graphics.setColor({1,1,1,1})
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
