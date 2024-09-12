return {
	name="TEACHING TIME", -- Top-Right Display String.
	id="tutorial",
	levelTitle="ui/story/labels/tutorial.png", -- looks in assets/images.
	songs={"Tutorial"}, -- Level song list.
	colour=Colour.rgb(249,207,81), -- Background Colour in story menu.
	otherProperties={
		allowModifiers=true, -- i.e: User Scroll Speed, User Playback Rate.
		allowMultiplayer=true, -- i.e: playing as the opponent with the alternative keybinds, if enabled.
		allowUserNoteskins=true, -- i.e: User-set noteskins instead of forcing the one from the song.
	},
	-- Allows the level to be shown or not in specific menus
	-- this can be just a boolean too, or a table like this, so you can be specific with it.
	visible={story=true,freeplay=true},
}
