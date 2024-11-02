local Paths = {}

local currentMod = "" --- @type string

function Paths.getPath(key)
  local root = "assets/"
  local modName = Paths.getCurrentMod()
  if love.filesystem.getInfo("mods/"..modName, "directory") ~= nil then
    return "mods/"..modName..key
  end
  return root..key
end

function Paths.getModule(key)
  local assetFolder = Paths.getPath(key)
	return string.gsub(assetFolder, "/", ".")
end

function Paths.getModuleRaw(key)
	return string.gsub(key, "/", ".")
end

--- Grabs the specified path and generates a love.Texture from it, nil if failed
---
--- @param key string       Path to image.
function Paths.getImage(key)
  local path = Paths.getPath(key)
  if love.filesystem.getInfo(path..".png","file").size ~= nil then
    return love.graphics.newImage(path..".png")
  end
  if love.filesystem.getInfo(path..".jpg","file").size ~= nil then
    return love.graphics.newImage(path..".jpg")
  end
  print("failed to grab image at path "..path)
  return nil
end

--- Checks whether a file existing using the LOVE filesystem API.
---
--- @param path string      File to look for.
--- @param fileType string  Type of file (i.e: file, directory, symlink, other)
---
--- @return boolean
function Paths.fileExists(path, fileType)
  local file = love.filesystem.getInfo(path)
  local typelowercase = string.lower(fileType)
  if file ~= nil and (not fileType or file.type == typelowercase)then return true end 
  return false
end

--- Switches from the current mod to a new one.
---
--- Returns `newMod` if sucessful, `currentMod` if failed
--- @param newMod string    New mod folder name.
---
--- @return string
function Paths.switchMod(newMod)
  if love.filesystem.getInfo("mods/"..newMod, "directory") ~= nil then
    currentMod = newMod
    return newMod
  end
  return currentMod
end

--- Returns the current active mod name.
--- @return string
function Paths.getCurrentMod()
  local modPath = currentMod
  if #modPath ~= 0 and string.last(modPath, "/") == false then
    modPath = modPath.."/"
  end
  return modPath
end

return Paths
