--- @class AssetManager
local AssetManager = {
    pathRedirect = "",
    imageCache = {},
    soundCache = {},
}

local DEFAULT_PATH = "res/"

local function appendSlash(str)
    if string.sub(str, #str - #"/" + 1, #str) ~= "/" then str = str.."/" end
    return str or ""
end

function AssetManager.getPath(asset)
    local p = appendSlash(DEFAULT_PATH)
    local pr = appendSlash(AssetManager.pathRedirect)
    local full = p..asset
    if #pr ~= 0 and love.filesystem.getInfo(pr..asset) then
        full = pr..asset
    end
    return full
end

function AssetManager.getImage(asset)
    asset = string.gsub(asset, "%.%w+$", "")
    local image = AssetManager.getPath(asset)
    if AssetManager.imageCache[image] then
        return AssetManager.imageCache[image]
    end
    local exts = {".png", ".jpg"}
    for i = 1, #exts do
        if love.filesystem.getInfo(image..exts[i]) then
            AssetManager.imageCache[image] = love.graphics.newImage(image..exts[i])
            break
        end
    end
    if AssetManager.imageCache[image] then
        return AssetManager.imageCache[image]
    else
        print("Tried to find image at \""..image.."\" which does not correspond to any file.")
        return nil
    end
end

function AssetManager.getSound(asset, streamed)
    streamed = streamed or false
    asset = string.gsub(asset, "%.%w+$", "")
    local sound = AssetManager.getPath(asset)
    if AssetManager.soundCache[sound] then
        return AssetManager.soundCache[sound]
    end
    local exts = {".ogg", ".wav", ".mp3"}
    for i = 1, #exts do
        if love.filesystem.getInfo(sound..exts[i]) then
            AssetManager.soundCache[sound] = love.audio.newSource(sound..exts[i], streamed and "stream" or "static")
            break
        end
    end
    if AssetManager.soundCache[sound] then
        return AssetManager.soundCache[sound]
    else
        print("Tried to find sound at \""..sound.."\" which does not correspond to any file.")
        return nil
    end
end

return AssetManager
