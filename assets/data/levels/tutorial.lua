return {
	name = "TEACHING TIME", -- Top-Right Display String.
	id = "tutorial",
	levelTitle = "ui/story/labels/tutorial.png", -- looks in assets.
	songs = {
		name = "Tutorial",
		folder = "tutorial",
		icon = "ui/icons/gf",
		colors = { Color.rgb(146, 113, 253), Color.WHITE() }, -- {Background Colour, Capsule Colour}
	}, -- Level song list.
	color = Color.rgb(249, 207, 81), -- Background Color in story menu.
	otherProperties = {
		allowModifiers = true, -- i.e: User Scroll Speed, User Playback Rate.
		allowMultiplayer = true, -- i.e: playing as the opponent with the alternative keybinds, if enabled.
		allowUserNoteskins = true, -- i.e: User-set noteskins instead of forcing the one from the song.
	},
	-- Allows the level to be shown or not in specific menus
	-- this can be just a boolean too, or a table like this, so you can be specific with it.
	visible = { story = true, freeplay = true },
}
