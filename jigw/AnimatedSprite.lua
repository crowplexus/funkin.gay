--- @enum AnimationRepeat
local AnimationRepeat = {
	NEVER = 0,
	ON_END = 1,
	TO_FRAME = 2,
}

local function buildAnimatedSprite(sel)
	sel.position = Vector3(0,0,0) -- X, Y, Z
	sel.zAsLayer = true -- treats Z position value as a layer index, is a toggle so you can use Z for something else
	sel.scale = Vector2(1,1)
	sel.colour = Colour.rgb(255,255,255)
	sel.visible = true
	sel.rotation = 0
	sel.alpha = 1.0
	sel.animations = {}
	sel.animation = {
		name = "default",
		progress = 0
	}
	sel.currentAnimation = nil
	sel.animationProgress = 0
	sel.texture = nil
	return sel
end

local function buildAnimation()
	return {
		name = "default",
		texture = tex or nil, --- @type love.graphics.Image
		quads = {}, --- @type love.graphics.Quad
		frameRate = 30, --- @type number
		offset = Vector2(0,0),
		repeatMode = AnimationRepeat.NEVER, --- @type number|AnimationRepeat
		--- is only valid if `repeatMode` gets set to 2|TO_FRAME
		--- @type number
		repeatFrame = nil,
		length = 0, --- @type number
	}
end

local AnimatedSprite = Object:extend()


function AnimatedSprite:new(x,y,tex)
	buildAnimatedSprite(self)
	self.position = Vector3(x,y,0)
	if tex then self.texture = tex end
end

function AnimatedSprite:update(dt)
	if self.currentAnimation ~= nil then
		local curAnim = self.animations[self.currentAnimation]
		local animationEnd = curAnim.length
		if self.animationProgress < animationEnd then
			self.animationProgress = self.animationProgress + dt / (curAnim.frameRate * 0.0018)
		else
			--- repeats the animation if we even can lol
			if curAnim.repeatMode == AnimationRepeat.NEVER then
				self.animationProgress = self.animationProgress - animationEnd
				return
			end
			local returnToFrame = self.animationProgress - animationEnd
			if curAnim.repeatMode == AnimationRepeat.TO_FRAME and curAnim.repeatFrame then
				returnToFrame = curAnim.repeatFrame
			end
			self.animationProgress = returnToFrame
		end
	end
end

function AnimatedSprite:addAnimation(name,x,y,width,height,fps,duration,tex)
	tex = tex or self.texture
	if tex == nil then
		print("Cannot add animation to a texture-less AnimatedSprite.")
		return nil
	end
	local anim = buildAnimation()
	anim.tex = tex
	anim.name = name or "default"
	anim.frameRate = fps or 30
	for _y = 0, tex:getHeight() - height, height do
		for _x = 0, tex:getWidth() - width, width do
			table.insert(anim.quads, love.graphics.newQuad(_x,_y,width,height,tex:getDimensions()))
		end
	end
	anim.length = duration or 1
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:addAnimationTransform(name,transform,fps,duration,tex)
	local anim = buildAnimation()
	anim.tex = tex or self.texture
	if anim.tex == nil then
		print("Cannot add animation to a texture-less AnimatedSprite.")
		return nil
	end
	anim.name = name or "default"
	anim.frameRate = fps or 30

	for i=1, #transform do
		local cfg = transform[i]
		local trimmed = cfg.frameX
		local frameRect = Rect2(cfg.x,cfg.y,cfg.width,cfg.height)
		if trimmed then
			local frameMargin = Rect2(cfg.frameX,cfg.frameY,cfg.frameWidth - frameRect.width,cfg.frameHeight - frameRect.height)
			if frameMargin.width < math.abs(frameMargin.x) then frameMargin.width = math.abs(frameMargin.x) end
			if frameMargin.height < math.abs(frameMargin.y) then frameMargin.height = math.abs(frameMargin.y) end
			Rect2.combine(frameRect,frameMargin)
		end
		table.insert(anim.quads, {
			quad = love.graphics.newQuad(frameRect.x,frameRect.y,frameRect.width,frameRect.height,anim.tex:getDimensions()),
			offset = not trimmed and Vector2(0, 0) or Vector2(cfg.frameX, cfg.frameY)
		})
		--print(Utils.tablePrint(anim.quads))
	end

	anim.length = duration or #anim.quads or 1
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:addOffsetToAnimation(name,x,y)
	local anim = self.animations[name]
	if anim == nil then
		print("Cannot add offset to a animation that doesn't exist.")
		return
	end
	anim.offset = Vector2(x,y)
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:playAnimation(name, forced)
	if not forced or type(forced) ~= "boolean" then forced = false end
	if self.animations and self.animations[name] then
		self.currentAnimation = self.animations[name].name
		if forced then self.animationProgress = 0 end
	end
end

function AnimatedSprite:dispose()
	for idx,anim in ipairs(self.animations) do
		for qd,prms in self.animations.quads do
			if prms.quad.release then prms.quad:release() end
			prms = nil
		end
		anim = nil
	end
	self.texture:release()
	buildAnimatedSprite(self)
end

function AnimatedSprite:draw()
	if self and self.texture and self.visible and self.colour[4] ~= 0.0 then
		love.graphics.setColor(self.colour)
		if self.currentAnimation == nil then
			love.graphics.draw(self.texture,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
		else
			local cur = self.animations[self.currentAnimation]
			local progress = math.floor(self.animationProgress / cur.length * #cur.quads) + 1
			if progress < 1 or progress > cur.length then progress = 1 end
			local animPos = {
				x = self.position.x + cur.offset.x + cur.quads[progress].offset.x,
				y = self.position.y + cur.offset.y + cur.quads[progress].offset.y
			}
			--print(progress)
			love.graphics.draw(cur.texture or self.texture,cur.quads[progress].quad,animPos.x,animPos.y,
					self.rotation,self.scale.x,self.scale.y)
		end
		love.graphics.setColor(Colour.rgb(1,1,1,1))
	end
end

function AnimatedSprite:screenCentre(_x_)
	_x_ = string.lower(_x_)
	local vpw, vph = love.graphics.getDimensions()
	local width, height = self.texture:getDimensions()
	local tex = self.animations[self.currentAnimation].texture or self.texture
	if string.find(_x_,"x") then
		self.position.x = (vpw-width)/2
	end
	if string.find(_x_,"y") then
		local height = tex:getHeight() or 0
		self.position.y = (vph-height)/2
	end
end

return AnimatedSprite
