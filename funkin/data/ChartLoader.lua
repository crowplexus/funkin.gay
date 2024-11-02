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
		--- Note judgement, given to a note when hitting or missing it.
		--- @type table<any>
		judgement = nil,
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

--- contains different IDs for chart types
--- @enum ChartType
ChartType = {
	FNF_LEGACY = 0,
	FNF_VSLICE = 1,
	FNF_PSYCH = 2,

	--- other formats ---

	STEPMANIA = 3,
	SM_SHARK = 4,
}

function ChartLoader:readLegacy(name, difficulty)
	name = name or "test"
	difficulty = difficulty or "normal"

	-- todo: look for every possible name for the json files
	local json = io.open(Paths.getPath("songs/" .. name .. "/" .. difficulty .. ".json"))
	local legacyChart = require("lib.json").decode(json:read("*a")).song

	if legacyChart == nil then
		print("Failed to parse chart " .. name .. " in difficulty " .. difficulty)
		return nil
	end

	--Utils.tablePrint(legacyChart, "json")

	local chart = ChartLoader.getTemplateSong()
	chart.type = ChartType.FNF_LEGACY

	local isPsych = false
	local curBPM = legacyChart.bpm or 100
	local crotchet = (60.0 / curBPM)
	local timePassed = 0.0
	local keyCount = 4

	local i = 1
	print("sections: " .. #legacyChart.notes)
	local total = 1

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
					if math.floor(curNote[1]) % (keyCount * 2) >= keyCount then
						note.player = not mustHitSection and 1 or 2
					end
					note.hold = { curNote[3], nil }
					note.type = curNote[4] or "normal"
					chart.notes[j] = note
				end
			end
			total = total + #curSection.sectionNotes
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
	print("total notes meant to be generated: " .. total)

	table.sort(chart.notes, function(a, b) return a.time < b.time end)
	table.sort(chart.events, function(a, b) return a.time < b.time end)

	return chart
end

function ChartLoader.getTemplateSong()
	return {
		name = "Unknown",
		artist = "Unknown",
		charter = "Unknown",
		generatedBy = "Hand",
		notes = {},  --- @type table
		type = ChartType.FNF_LEGACY,
		events = {}, --- @type table
		tempoChanges = {}, --- @type table
	}
end

function ChartLoader.getTemplateMetadata()
	return {
		bpm = {
			easy = 100,
			normal = 100,
			hard = 100,
			erect = 100,
			nightmare = 100,
		},
		scrollSpeed = {
			easy = 1,
			normal = 1,
			hard = 1,
			erect = 1,
			nightmare = 1,
		},
	}
end

return ChartLoader
