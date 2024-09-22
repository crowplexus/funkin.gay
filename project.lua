--- Contains window configuration + game rules for the project.
--- Most of these can be changed without this file, this simply defines DEFAULTS.
--- @type table
local Project = {
  -- CONFIGURATION --

  title         = "Friday Night Funkin' (Kiskadee)", -- Game Window Title
  executable    = "Funkin-Kiskadee",                 -- Executable File Name
  wwidth        = 1280,                              -- Window Width
  wheight       = 720,                               -- Window Height

  -- GAME RULES --

  allowEpics    = true,         -- Enables the new 5th judgement, set to false if you don't need/want
  allowLocales  = true,         -- Enables in-game translations, disable for English(AU)-only
  allowDiscord  = true,         -- discord
  allowMods     = true,         -- mods
}
return Project