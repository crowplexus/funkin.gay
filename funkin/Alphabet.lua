local Alphabet = Classic:extend("Alphabet") --- @class Alphabet
local AtlasFrameHelper = require("jigw.util.AtlasFrameHelper")

local X_PER_SPACE = 40
local Y_PER_COLUMN = 20

local spritePath = "ui/menu/alphabet"
local _cachedAnimations = {} --- @type table

local function initBatch(self, len)
	if self._batch ~= nil then
		self._batch:release()
	end
	self._batch = love.graphics.newSpriteBatch(self.texture, len)
end

local function fixname(x)
	x = string.upper(x) or ""
	Utils.match(x, {
		["&"] = function() return "amp" end,
	})
	return x
end

--- Constructs a new Alphabet text object used in the menus.
--- @param x number			X coordinate to draw the text to.
--- @param y number			Y coordinate to draw the text to.
--- @param newtext string	Text to display.
function Alphabet:construct(x, y, newtext)
	self.position = Vector2(x, y)                                                          --- @class jigw.util.Vector2
	self.scale = Vector2(1, 1)                                                             --- @class jigw.util.Vector2
	self.rotation = 0                                                                      --- @type number
	self.visible = true                                                                    --- @type boolean
	self.isMenuItem = false                                                                --- @type boolean
	self.indexY = 0                                                                        --- @type number
	self.color = Color.WHITE()                                                             --- @type table<number>
	self.alpha = 1.0                                                                       --- @type number
	self.texture = love.graphics.newImage(Paths.getPath(spritePath .. ".png"))             --- @class love.Image
	_cachedAnimations = AtlasFrameHelper.getSparrowAtlas(Paths.getPath(spritePath .. ".xml")) --- @type table
	initBatch(self, #newtext or 50)
	self.text = newtext or ""                                                              --- @type string
end

function Alphabet:update(dt)
	if self.isMenuItem == true then
		local scaledY = math.remapRange(self.indexY,0,1,0,1.3)
		local sWidth = (love.graphics:getWidth() * 0.25)
		self.position.y = math.lerp(self.position.y, (scaledY * 120) + sWidth, 0.16)
		self.position.x = math.lerp(self.position.x, (self.indexY * 20) + 90, 0.16)
	end
end

function Alphabet:set_text(vl)
	vl = string.gsub(vl, "\\n", "\n")
	rawset(self, "text", vl)

	local offsetX = 0
	local offsetY = 0
	local chars = string.split(vl)
	local animList = _cachedAnimations

	local i = 1
	while i <= #chars do
		local char = fixname(chars[i])
		local space = char == " "
		local lbreak = char == "\n"

		if space then
			offsetX = offsetX + X_PER_SPACE
			return
		end
		if lbreak then
			offsetY = offsetY + Y_PER_COLUMN
			offsetX = 0
			return
		end

		local letter = AtlasFrameHelper.buildSparrowQuad(animList[char .. " bold"].frames, self.texture)
		if self._batch then
			local _, _, wh, ht = letter[1].quad:getViewport()
			self._batch:add(letter[1].quad, offsetX, offsetY)
			--print("added character " .. char)
			offsetX = offsetX + wh
		end
		i = i + 1
	end
	return vl
end

function Alphabet:draw()
	if not self.visible then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	--local frW, frH = self.texture:getDimensions()
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
	love.graphics.scale(self.scale.x, self.scale.y)
	love.graphics.draw(self._batch, 0, 0)
	--love.graphics.setColor(Color.WHITE())
	love.graphics.pop()
end

function Alphabet:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if _x_ == Axis.XY then
		centerX = true
		centerY = true
	end
	if centerX then
		self.position.x = vpw * 0.5
	end
	if centerY then
		self.position.y = vph * 0.5
	end
	--self.centered = centerX == true or centerY == true
end

function Alphabet:get_alpha()
	return self.color[4]
end

function Alphabet:set_alpha(vl)
	self.color[4] = vl
end

return Alphabet
