local LevelProgressor = require("funkin.game.Progression")
function getGameMetadata()
	local darnellSongList = {"Darnell","Lit-Up","2hot","Blazin'"}
	if not LevelProgressor:isLevelBeaten("weekend1") then
		table.remove(darnellSongList, #darnellSongList)
	end
	return {
		name="Friday Night Funkin'",
		levels={
			-- you can switch between level categories in the story menu
			-- by pressing Q/E, and those are shown as folders in Freeplay.
			["Main Story"] = {
				{
					name="TEACHING TIME", -- Top-Right Display String.
					id="tutorial",
					levelTitle="ui/story/labels/tutorial.png", -- looks in assets/images.
					colour=Colour.rgb(249,207,81), -- Background Colour in story menu.
					otherProperties={
						allowModifiers=true, -- i.e: User Scroll Speed, User Playback Rate.
						allowMultiplayer=true, -- i.e: playing as the opponent with the alternative keybinds, if enabled.
						allowUserNoteskins=true, -- i.e: User-set noteskins instead of forcing the one from the song.
					}
				}
			},
			["Side-Story"] = {
				{
					name="Due Debts",
					id="weekend1",
					levelTitle="ui/story/labels/weekend1.png",
					songs=darnellSongList,
					colour=Colour.rgb(65,60,174),
					otherProperties=nil -- allows everything listed above if so.
				}
			}
		}
	}
end
