local Sound = {
	sourcesCached = {},
	soundsPlaying = {},
	music 				= nil,
}

function Sound.update(dt)
	Sound.forEachSfx(function(sound,id)
		-- this might not be the best solution but hwere we have it ig
		if sound ~= nil and not sound:isPlaying() then
			table.remove(Sound.soundsPlaying,id)
			sound:release()
			sound = nil
		end
		--print("Sound Effects being played:"..#Sound.soundsPlaying)
	end)
end

--- Used for caching audio sources and releasing them later when finished.
--- @param file				File path (with sound extension included at the end)
--- @param sourceType Streaming or static source. ("static", stream")
function Sound.makeSource(file,sourceType)
	local src = love.audio.newSource(file,sourceType)
	table.insert(Sound.soundsPlaying,src)
	return src
end

--- Creates a background music stream and immediately plays it.
--- @param file				File path (with sound extension included at the end)
--- @param sourceType Streaming or static source. ("static", stream")
--- @param volume 		Initial volume.
--- @param looped			Sets whether the BGM should loop.
function Sound.playMusic(file,sourceType,volume,looped)
	local bgm = love.audio.newSource(file,sourceType)
	bgm:setLooping(looped or false)
	bgm:setVolume(volume or 1.0)
	bgm:play()
	-- replace this later ig?
	Sound.music = bgm
end

--- Creates a sound effect stream and immediately plays it.
--- @param file				File path (with sound extension included at the end)
--- @param sourceType Streaming or static source. ("static", stream")
--- @param volume 		Initial volume.
function Sound.playSound(file,sourceType,volume)
	local sfx = love.audio.newSource(file,sourceType)
	sfx:setVolume(volume or 1.0)
	sfx:play()
	table.insert(Sound.soundsPlaying,sfx)
end

--- Stops the background music abruptly.
--- @param release			Clears the audio completely from memory.
function Sound.stopMusic(release)
	if type(release) ~= "boolean" then release = true end
	if Sound.music and Sound.music.stop then
		Sound.music:stop()
	end
	if release == true then
		if Sound.music.release then Sound.music:release() end
		Sound.music = nil
	end
end

--- Stops every sound effect abruptly.
--- @param releaseAll		Clears the sounds completely from memory.
function Sound.stopAll(releaseAll)
	if #Sound.soundsPlaying == 0 then return end
	for i=1,#Sound.soundsPlaying do
		local sfx = Sound.soundsPlaying[i]
		if sfx == nil then return end
		if sfx.stop then
			sfx:stop()
		end
		if releaseAll == true then
			if sfx.release then sfx:release() end
			table.remove(Sound.soundsPlaying,i)
			sfx = nil
		end
	end
end

function Sound.forEachSfx(func)
	if type(func) ~= "function" then return end
	if #Sound.soundsPlaying == 0 then return end
	for i=1,#Sound.soundsPlaying do
		local sfx = Sound.soundsPlaying[i]
		func(sfx,i)
	end
end

return Sound
