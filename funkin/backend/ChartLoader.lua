local ChartLoader = {}

local function generateNote()
	return {
		--- Time (in seconds) to spawn the note.
		--- @type number
		time = 0,
		--- a note's column.
		--- @type number
		column = 0,
		--- a note's type, if nil or empty, this is a normal note.
		--- @type string
		type = nil,
		--- Hold Note data, contains size and type.
		---
		--- e.g: {50.0, "normal"}
		--- @type table<[number,string]>
		hold = { 0.0, nil },
		--- Player Notefield ID.
		--- @type number
		player = 0,
	}
end

local function generateEvent()
	return {
		--- Internal Name for the event
		--- @type string
		__name = "my_event",
		--- Display Name, used for formatting
		---
		--- if unspecified, `__name` will be used in its place.
		--- @type string
		displayName = "My Event",
		--- Time (in seconds) to execute the event.
		--- @type number
		time = 0.0,
		--- Event argument list.
		--- @type table<any>
		arguments = {},
	}
end

local function generateTimeChange()
	return {
		bpm = nil,                    --- @type number
		beat = nil,                   --- @type number
		time = nil,                   --- @type number
		crotchet = nil,               --- @type number
		signature = { nume = 4, deno = 4 }, --- @type table<table<number>>
	}
end

--- Contains different IDs for chart types
--- @enum ChartType
ChartType = {
	CUSTOM = 0,
	FNF_LEGACY = 1,
	FNF_VSLICE = 2,
	FNF_PSYCH = 3,
	STEPMANIA = 4,
	SM_SHARK = 5,
}

function ChartLoader.readLegacy(name, difficulty)
	name = name or "test"
	difficulty = difficulty or "normal"

	-- todo: look for every possible name for the json files
	local json = io.open(Paths.getPath("songs/" .. name .. "/" .. difficulty .. ".json"))
	if json == nil then
		print("Failed to parse chart " .. name .. " in difficulty " .. difficulty)
		return nil
	end

	local legacyChart = require("lib.json").decode(json:read("*a")).song
	if legacyChart == nil then
		print("Failed to parse chart " .. name .. " in difficulty " .. difficulty)
		return nil
	end

	--Utils.tablePrint(legacyChart, "json")

	local chart = ChartLoader.getTemplateChart()
	chart.metadata = ChartLoader.readMeta(name)
	chart.type = ChartType.FNF_LEGACY

	local function setDefaultIfNull(key, value, nullv)
		if chart.metadata[key][_] == nullv then
			chart.metadata[key][_] = value
		end
	end

	setDefaultIfNull("bpm", legacyChart.bpm, -1)
	setDefaultIfNull("scrollSpeed", legacyChart.speed, -1)
	setDefaultIfNull("artist", legacyChart.artist or "Unknown", "nil")
	setDefaultIfNull("charter", legacyChart.charter or "Unknown", "nil")

	local isPsych = false
	local curBPM = legacyChart.bpm or 100
	local crotchet = (60.0 / curBPM)
	local timePassed = 0.0
	local keyCount = 4

	local i = 1
	local totalNotesPushed = 1
	print("sections: " .. #legacyChart.notes)

	while i <= #legacyChart.notes do
		local curSection = legacyChart.notes[i]
		if not isPsych and curSection.sectionBeats ~= nil then
			chart.type = ChartType.FNF_PSYCH
			isPsych = true
		end

		-- NOTE GENERATION --
		if curSection.sectionNotes ~= nil then
			local mustHitSection = curSection.mustHitSection or false
			for j = 1, #curSection.sectionNotes do --- actual notes
				-- i genuinely hate this format
				local curNote = curSection.sectionNotes[j]
				if curNote ~= nil and curNote[1] ~= nil then
					local note = generateNote()
					local rawColumn = math.floor(curNote[2])
					note.time = tonumber(curNote[1] * 0.001) or 0.0
					note.column = math.floor(curNote[2] % 4)
					note.player = mustHitSection and 1 or 2
					if rawColumn % (keyCount * 2) >= keyCount then
						note.player = not mustHitSection and 1 or 2
					end
					note.hold = { curNote[3], nil }
					note.type = curNote[4] or "normal"
					chart.notes[j] = note
				end
			end
			totalNotesPushed = totalNotesPushed + #curSection.sectionNotes
		end

		-- EVENT GENERATION --
		if curSection.changeBPM == true and curSection.bpm ~= curBPM then
			local bpmChange = generateTimeChange()
			bpmChange.bpm = curSection.bpm
			bpmChange.time = timePassed
			bpmChange.crotchet = crotchet
			bpmChange.signature = { nume = 4, deno = 4 }
			chart.tempoChanges[#chart.tempoChanges + 1] = bpmChange
			crotchet = (60.0 / curBPM)
			curBPM = curSection.bpm
		end

		local cameraEvent = generateEvent()
		cameraEvent.displayName = "Camera Focus Change"
		cameraEvent.arguments = { curSection.mustHitSection and 1 or 0, "classic" }
		cameraEvent.time = timePassed
		chart.events[#chart.events + 1] = cameraEvent

		-- increase the time passed since we began parsing these
		timePassed = timePassed + crotchet * 4
		i = i + 1
	end
	print("total notes meant to be generated: " .. totalNotesPushed)

	table.sort(chart.notes, function(a, b) return a.time < b.time end)
	table.sort(chart.tempoChanges, function(a, b) return a.time < b.time end)
	table.sort(chart.events, function(a, b) return a.time < b.time end)

	return chart
end

function ChartLoader.readMeta(song)
	song = song or "test"

	local metaTable = ChartLoader.getTemplateMetadata()

	local json = io.open(Paths.getPath("songs/" .. name .. "/_meta.json"))
	if json == nil then
		print("Failed to parse chart metadata " .. name)
		return metaTable
	end

	local chartMeta = require("lib.json").decode(json:read("*a"))
	if chartMeta == nil then
		print("Failed to parse chart metadata " .. name)
		return metaTable
	end

	local function setMetaOrDefault(key, value)
		if chartMeta[key] then
			if type(value) == "table" then
				metaTable[key] = chartMeta[key]
			else
				metaTable[key][_] = chartMeta[key]
			end
		end
	end

	setMetaOrDefault("bpm", chartMeta.bpm)
	setMetaOrDefault("scrollSpeed", chartMeta.scrollSpeed)
	setMetaOrDefault("instrumental", chartMeta.instrumental)
	setMetaOrDefault("charter", chartMeta.charter)
	setMetaOrDefault("artist", chartMeta.artist)
	setMetaOrDefault("vocals", chartMeta.vocals)

	return metaTable
end

--- I still don't know how I'm gonna do this and all
function ChartLoader.getTemplateChart()
	return {
		name = "Unknown",
		notes = {},  --- @type table
		events = {}, --- @type table
		tempoChanges = {}, --- @type table
		type = ChartType.CUSTOM,
		generatedBy = "Hand",
	}
end

function ChartLoader.getTemplateMetadata()
	-- "_" means default for all difficulties
	return {
		bpm = { _ = -1, },
		scrollSpeed = { _ = -1, },
		instrumental = { _ = "Inst" },
		vocals = { _ = { "Voices" } },
		charter = { _ = "nil" },
		artist = { _ = "nil" },
	}
end

return ChartLoader
