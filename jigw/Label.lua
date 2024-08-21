local function resetVars(x)
	x = {
		text = nil,
		position = {x = 0, y = 0},
		scale = {x = 1, y = 1},
		color = {1,1,1,1},
		rotation = 0,
		--alpha = 1.0,
		strokeSize = 1,
		strokeColour = {0,0,0,1},
		fontPath = "assets/fonts/vcr.ttf",
		fontSize = 14,
		_font = nil,
	}
	return x
end

local Label = resetVars({})
Label.__index = Label

local function _recreateFont(self) -- gonna be doing this a lot
	if self._font then self._font:release() end
	self._font = love.graphics.newFont(self.fontPath,self.fontSize,"none")
end

local function _isFontPath(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

function Label:new(x,y,text,size)
	local self = setmetatable(Label, {})
	self.__index = self
	self.position.x = x or 0
	self.position.y = y or 0
	self.text = text or ""
	self.fontSize = size or 14
	self:changeFontSize(size, true)
	return self
end

function Label:dispose()
	self._font:release()
	resetVars(self)
end

function Label:draw()
	if self and self:has_any_text() then
		-- TODO: use printf for alignments
		love.graphics.setColor(self.color)
		love.graphics.print(self.text,self._font,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
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
end

--#region Getters and Setters
--function Label:get_alpha() return rawget(self,self.color[4]) end
--function Label:set_alpha(vl) return rawset(self,self.color[4],vl) end
--#endregion

function Label:__index(idx)
  -- custom getter functionality
  if rawget(self,"get_"..idx) then return rawget(self,"get_"..idx)() end
  return rawget(self,idx)
end

function Label:__newindex(idx,vl)
  -- custom setter functionality
  if rawget(self,"set_"..idx) then return rawget(self,"set_"..idx)(self,vl)
  else return rawset(Label,idx,vl) end
end

return Label
