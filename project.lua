--- Contains window configuration + game rules for the project.
--- Most of these can be changed without this file, this simply defines DEFAULTS.
--- @type table
local Project = {
	-- CONFIGURATION --

	title = "Friday Night Funkin'", --- @type string Window title bar text
	saveFolder = "crowplexus/funkin", --- @type string Executable file name
	wwidth = 1280,                 --- @type number Window Width
	wheight = 720,                 --- @type number Window Height
}
return Project
