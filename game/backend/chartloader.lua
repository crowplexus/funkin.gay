local ChartLoader = {}
local Json = require("lib.json")

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
	FNF             = "FNF",
	STEPMANIA       = "Stepmania",
	CUSTOM          = "Custom",
    function matches(str, t)
        -- uses string.first
        return string.sub(str, 1, #t) == t
    end,
}

function ChartLoader.readLegacy(name, difficulty)
	name = name or "test"
	difficulty = difficulty or "normal"

	-- todo: look for every possible name for the json files
	local json = io.open(AssetManager.getPath("songs/" .. name .. "/" .. difficulty .. ".json"))
	if json == nil then
		print("Failed to parse chart " .. name .. " in difficulty " .. difficulty)
		return nil
	end

	local jsonData = Json.decode(json:read("*a"))
	if jsonData == nil then
		print("Failed to parse chart " .. name .. " in difficulty " .. difficulty)
		return nil
	end

	local chart = ChartLoader.getTemplateChart()
    ---- PARSE CHART ----
    if type(jsonData.song) == "table" then
        jsonData = jsonData.song
    end
	
	chart.metadata = ChartLoader.readMeta(name)
	local psychV1String = nil
    if not isPsych then
        if not jsonData.format then
            chart.type = ChartType.FNF.."(Legacy)"
        else
            if #jsonData.format ~= 0 then
                chart.type = ChartType.FNF.."("..jsonData.format..")"
            else
                chart.type = ChartType.FNF.."(Psych 1.0+)"
            end
			psychV1String = chart.type
        end
    end

	local function setDefaultIfNull(key, value, nullv)
		if chart.metadata[key][_] == nullv then
			chart.metadata[key][_] = value
		end
	end

	setDefaultIfNull("bpm", jsonData.bpm, 100.0)
	setDefaultIfNull("scrollSpeed", jsonData.speed, 1.0)
	setDefaultIfNull("artist", jsonData.artist, "Unknown")
	setDefaultIfNull("charter", jsonData.charter, "Unknown")
	setDefaultIfNull("generatedBy", jsonData.generatedBy, "Unknown")
    
    local isPsych = false
	local curBPM = jsonData.bpm or 100
	local crotchet = (60.0 / curBPM)
	local timePassed = 0.0
	local keyCount = 4

	local i = 1
	local daBeats = 1 -- dabeats part 2
	-- print("measures: " .. #jsonData.notes)

	while i <= #jsonData.notes do
		local curSection = jsonData.notes[i]
		if not isPsych and curSection.sectionBeats ~= nil then
			chart.type = ChartType.FNF.."(Psych 0.6~0.7.3)"
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
					if rawColumn % (keyCount * 2) >= keyCount and chart.type ~= psychV1String then
						note.player = not mustHitSection and 1 or 2
					end
					note.hold = { curNote[3], nil }
					note.type = curNote[4] or "normal"
					chart.notes[j] = note
				end
			end
			daBeats = daBeats + #curSection.sectionNotes
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
	-- print("total notes meant to be generated: " .. daBeats)

	return chart
end

function ChartLoader.readMeta(song)
	song = song or "test"

	local metaTable = ChartLoader.getTemplateMetadata()

	local json = io.open(AssetManager.getPath("songs/" .. name .. "/_meta.json"))
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

-- I still don't know how I'm gonna do this and all

function ChartLoader.getTemplateChart()
	return {
		name = "Unknown",
		notes = {},  --- @type table
		events = {}, --- @type table
		tempoChanges = {}, --- @type table
		type = ChartType.CUSTOM, --- @type number
		generatedBy = "nil", --- @type string
	}
end

function ChartLoader.getTemplateMetadata()
	-- "_" means default for all difficulties
	return {
		bpm = { _ = -1, },
		scrollSpeed = { _ = -1, },
		instrumental = { _ = "Inst" },
		vocals = { _ = { "Voices" } },
		charter = { _ = "Unknown" },
		artist = { _ = "Unknown" },
	}
end

return ChartLoader
