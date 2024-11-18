--- Contains window configuration + game rules for the project.
--- Most of these can be changed without this file, this simply defines DEFAULTS.
--- @type table
local Project = {
	-- CONFIGURATION --

	title = "Friday Night Funkin' (Kiskadee)", --- @type string Window title bar text
	executable = "Funkin-Kiskadee",         --- @type string Executable file name
	wwidth = 1280,                          --- @type number Window Width
	wheight = 720,                          --- @type number Window Height

	-- GAME RULES --

	allowEpics = true, --- @type boolean Enables the new 5th judgement, set to false if you don't need/want
	allowLocales = true, --- @type boolean Enables in-game translations, disable for English(AU)-only
	allowDiscord = true, --- @type boolean discord
	allowMods = true, --- @type boolean mods
}
return Project
