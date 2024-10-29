local list = {
	{
		name = "Tutorial",
		folder = "tutorial",
		icon = "ui/icons/gf",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() }, -- {Background Colour, Capsule Colour}
	},
	{
		name = "Bopeebo",
		folder = "bopeebo",
		icon = "ui/icons/dad",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() },
	},
	{
		name = "Fresh",
		folder = "fresh",
		icon = "ui/icons/dad",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() },
	},
	{
		name = "DadBattle",
		folder = "dadbattle",
		icon = "ui/icons/dad",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() },
	},
}

local function getSongsInLevels()
	local modData = Paths.getPath("data/modData")
	local levels = require(string.gsub(modData, "/", "."))
	print(levels.GetLevels())
end

return list
