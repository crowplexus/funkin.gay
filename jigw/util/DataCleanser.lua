--- Script responsible for clearing unused data from the game
--- such as unused textures, audio streams, and other data.
DataCleanser = {
  collectedImages = {}, --- @type table<love.Image>
  collectedSounds = {}, --- @type table<love.SoundData>
}

--- @param img love.Image
function DataCleanser:disposeImage(img)
  if DataCleanser.collectedImages[img] then
    img:release()
  end
end

--- @param snd love.SoundData
function DataCleanser:disposeSound(snd)
  if DataCleanser.collectedSounds[snd] then
    snd:release()
  end
end

return DataCleanser
