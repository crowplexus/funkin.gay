--- Script responsible for clearing unused data from the game
--- such as unused textures, audio streams, and other data.
DataCleanser = {
  collected_images = {}, --- @type table<love.Image>
  collected_sounds = {}, --- @type table<love.SoundData>
}

--- @param img love.Image
function DataCleanser:dispose_image(img)
  if DataCleanser.collected_images[img] then
    img:release()
  end
end

--- @param snd love.SoundData
function DataCleanser:dispose_sound(snd)
  if DataCleanser.collected_sounds[snd] then
    snd:release()
  end
end

return DataCleanser
