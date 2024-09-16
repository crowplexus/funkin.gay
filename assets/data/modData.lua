function getLevels()
	local packsToFind = {
		-- ["Pack Name"] = {level_ids_as_string},
		["Main Story"] = {"tutorial","week1","week2","week3"},
		["Side-Story"] = {"weekend1"}
	}
	local LevelDatabase = require("funkin.data.LevelDatabase")
	LevelDatabase:clear() -- should do this automatically BUT its here to be sure everything's good.
	LevelDatabase:setWorkingDirectory("assets/data/levels/") -- this is default but, if you need to switch folders...
	-- if you wanna do something with the level data, put this on a local and do it
	-- then return it, we just return here cus it's all we need :>
	return LevelDatabase:deepPackSearch(packsToFind)
end

function getGameName() return "Friday Night Funkin'" end
-- return a string following this versioning schema:
-- Major.Minor.Patch-releaseType
-- release types can be either:
--	Prototype
--	Alpha
--	Beta
--	Prerelease
--	Release
-- doesn't matter how you spell it, uppercase first, all lowercase, all uppercase
-- everything should just work fine
function getGameVersion() return "0.3.0-prototype" end
