--- classes ---
local LevelProgressor = require("funkin.game.Progression")
local LevelDatabase = require("funkin.core.modding.LevelDB")
--- so we can do it big and manipulate thew song list :>
local beaten = LevelProgressor:isLevelBeaten("weekend1")
local darnellSongList = { "Darnell", "Lit-Up", "2hot", "Blazin'" }
local inFreeplay = LevelDatabase:getRequestedScreen() == "FreeplayMenu"
local showInFreeplay = inFreeplay and beaten
---
if not beaten then -- remove blazin' if you haven't beaten the level
	table.remove(darnellSongList, #darnellSongList)
end
return { -- and now here's the level data, have fun with that.
	name = "Due Debts",
	id = "weekend1",
	levelTitle = "ui/story/labels/weekend1.png",
	songs = not showInFreeplay and darnellSongList or {},
	color = Color.rgb(65, 60, 174),
	otherProperties = nil, -- allows everything.
	visible = true, -- will be ignored in freeplay unless you've beaten it and stuff !
	isLocked = false,
}
