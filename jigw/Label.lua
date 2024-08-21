local Label = Object:extend()

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
	self.text = text or nil
	self.fontPath = "assets/fonts/vcr.ttf"
	self.fontSize = size or 14
	self.position = Point2(x,y)
	self.size = Point2(0,0)
	self.scale = Point2(1,1)
	self.strokeSize = 1
	self.strokeColour = {0,0,0,1}
	self.colour = {1,1,1,1}
	self.textWidth = 0
	self.textHeight = 0
	self.rotation = 0
	self.alpha = 1.0
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
	if self and self:has_any_text() then
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
function Label:get_alpha() return rawget(self,self.color[4]) end
function Label:set_alpha(vl) return rawset(self,self.color[4],vl) end
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
