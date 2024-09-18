local function buildLabel(sel)
	sel.text = nil
	sel.fontSize = 14
	sel.fontPath = "assets/fonts/vcr.ttf"
	sel.position = Vector3(0,0,0)
	sel.zAsLayer = true
	sel.size = Vector2(0,0)
	sel.scale = Vector2(1,1)
	sel.strokeSize = 0
	sel.strokeColor = Color.rgb(0,0,0)
	sel.color = Color.rgb(255,255,255)
	sel.visible = true
	sel.textWidth = 0
	sel.textHeight = 0
	sel.rotation = 0
	sel.alpha = 1.0
	return sel
end

local Label = Object:extend()
function Label:__tostring() return "Label" end

local function _recreateFont(sel)
	if sel._renderFont then sel._renderFont:release() end
	sel._renderFont = love.graphics.newFont(sel.fontPath,sel.fontSize,"none")
end

local function _recreateText(sel)
	if sel._renderText then sel._renderText:release() end
	sel._renderText = love.graphics.newText(sel._renderFont or love.graphics.getFont(),sel.text)
	sel.size.x = sel._renderText:getWidth()
	sel.size.y = sel._renderText:getHeight()
end

local function _isFontPath(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

--- Function to draw a label's text field with a stroke below it.
--- @param t love.graphics.Text Text object.
--- @param c table<number> Text color.
--- @param sc table<number> Text stroke color.
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
    love.graphics.draw(t, x + sz, y + sz + offset, r, sx, sy)
    love.graphics.draw(t, x + sz + offset, y + sz, r, sx, sy)
    love.graphics.draw(t, x + sz - offset, y + sz + offset, r, sx, sy)
    love.graphics.draw(t, x + sz + offset, y + sz - offset, r, sx, sy)
    offset = -offset
  end
  love.graphics.setColor(c)
  love.graphics.draw(t,x+sz,y+sz,r,sx,sy)
  love.graphics.setColor(1,1,1,1)
end

function Label:new(x,y,text,size)
	buildLabel(self)
	self.position = Vector3(x,y,0)
	self.text = text or nil
	self.fontSize = size or 14
	self._renderFont = nil
	self._renderText = nil
	self:changeFontSize(size,true)
	--return self
end

function Label:dispose()
	self._renderFont:release()
	buildLabel(self)
end

function Label:draw()
	if self:hasAnyText() and self.visible and self.color[4] > 0.0 then
		if self.strokeSize > 0 then
			_drawWithStroke(
				self._renderText,self.color,self.strokeColor,
				self.position.x,self.position.y,self.rotation,self.strokeSize,
				self.scale.x, self.scale.y)
		else
			love.graphics.setColor(self.color)
			love.graphics.draw(self._renderText,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		end
		love.graphics.setColor(1,1,1,1)
	end
end

function Label:hasAnyText()
	return type(self.text) == "string" and string.len(self.text) ~= 0
end

function Label:setText(newtext) -- setter wasn't working fuckkkkk
	if not self._renderText then _recreateText(self) end
	self._renderText:set(newtext)
end

function Label:changeFont(path)
	local fi = love.filesystem.getInfo(path)
	if _isFontPath(path) and fi and fi.size and self.fontPath ~= path then
		self.fontPath = path
		_recreateFont(self)
		if self._renderText == nil then _recreateText(self) end
		self._renderText.setFont(self._renderFont)
	end
end

function Label:changeFontSize(newSize, force)
	self.fontSize = newSize
	_recreateFont(self)
	_recreateText(self)
end

function Label:centerPosition(_x_)
	_x_ = string.lower(_x_)
	local vpw, vph = love.graphics.getDimensions()
	if string.find(_x_,"x") then
		local width = self._renderText:getWidth() or 0
		self.position.x = (vpw-width)*0.5
	end
	if string.find(_x_,"y") then
		local height = self._renderText:getHeight() or 0
		self.position.y = (vph-height)*0.5
	end
end

--#region Getters and Setters
function Label:get_alpha() return rawget(self,self.color[4]) end
function Label:set_alpha(vl) return rawset(self,self.color[4],vl) end
--#endregion

return Label
