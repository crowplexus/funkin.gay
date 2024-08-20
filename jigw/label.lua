local function reset_vars(x)
	x = {
		text = nil,
		position = {x = 0, y = 0},
		scale = {x = 1, y = 1},
		color = {1,1,1,1},
		rotation = 0,
		--alpha = 1.0,
		stroke_size = 1,
		stroke_color = {0,0,0,1},
		font_path = "assets/fonts/vcr.ttf",
		font_size = 14,
		_font = nil,
	}
	return x
end

local Label = reset_vars({})
Label.__index = Label

local function _recreate_font(self) -- gonna be doing this a lot
	if self._font then self._font:release() end
	self._font = love.graphics.newFont(self.font_path,self.font_size,"none")
end

local function _is_font_path(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

function Label:new(x,y,text,size)
	local self = setmetatable(Label, {})
	self.__index = self
	self.position.x = x or 0
	self.position.y = y or 0
	self.text = text or ""
	self.font_size = size or 14
	self:change_font_size(size, true)
	return self
end

function Label:dispose()
	self._font:release()
	reset_vars(self)
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

function Label:change_font(path)
	local fi = love.filesystem.getInfo(path)
	if _is_font_path(path) and fi and fi.size and self.font_path ~= path then
		self.font_path = path
		_recreate_font(self)
	end
end

function Label:change_font_size(new_size, force)
	if force == false then
		if type(new_size) ~= "number" or new_size == self.font_size then
			new_size = _font_size
			return
		end
	end
	self.font_size = new_size
	_recreate_font(self)
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
