--- @class AtlasSprite
local AtlasSprite = Class("AtlasSprite", AnimatedSprite)

local AtlasFrameHelper = require("game.backend.atlasframes")
local _cached = {
    atlasanims = nil,
    path = nil,
}

local function _addAtlasAnimations(self, ...)
    local tbl = { ... }
    local atlas = _cached.atlasanims[tbl[2]]
    if atlas == nil then
        assert("No frames found for this animation, did you call loadSparrowAtlas? or maybe it's a typo?")
        return
    end
    self:addAnimation(tbl[1], AtlasFrameHelper.buildSparrowQuad(atlas.frames, self.texture),
        tbl[4] or false, tbl[3] or 24, #atlas.frames)
end

function AtlasSprite:loadSparrowAtlas(path, animations)
    path = string.gsub(path, "%.%w+$", "")
    self.texture = AssetManager.getImage(path .. ".png")
    if _cached.path ~= path then
        _cached.atlasanims = AtlasFrameHelper.getSparrowAtlas(AssetManager.getPath(path .. ".xml"))
        _cached.path = path
    end
    animations = animations or {}
    for i = 1, #animations do
        local name, prefix, fps, looped = unpack(animations[i])
        _addAtlasAnimations(self, name, prefix, fps or 24, looped or false)
    end
end

function AtlasSprite:addAnimationFromPrefix(name, prefix, fps, looped)
    if self.texture == nil then
        assert("There is no texture set for this AnimatedSprite")
        return
    end
    if _cached.path == nil then
        assert("No frames found for this animation, did you call loadSparrowAtlas?")
        return
    end
    _addAtlasAnimations(self, name, prefix, fps, looped)
end

return AtlasSprite
