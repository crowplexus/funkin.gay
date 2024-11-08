--- Useful time related functions.
--- @class TimeUtil
local TimeUtil = {}

--- Calcualtes the music crotchet based on bpm.
--- @param bpmVal? number  BPM value.
--- @return number
function TimeUtil.calculateCrotchet(bpmVal)
    bpmVal = bpmVal or 100.0
    return (60 / bpmVal)
end

--- Converts time (milliseconds) into seconds.
--- @param time number      Time in milliseconds.
--- @return number
function TimeUtil.millisToSecs(time) return time * 0.001 end

--- Converts time (seconds) into milliseconds.
--- @param time number      Time in seconds.
--- @return number
function TimeUtil.secsToMillis(time) return time * 1000.0 end

--- Transforms a beat into time.
--- @param beat number beat number
--- @param bpm? number BPM value, defaults to 100.
--- @return number
function TimeUtil.beatToTime(beat, bpm)
    beat = beat or 0.0
    bpm = bpm or 100.0
    return (beat * 60.0) / bpm
end

--- Transforms time into a step.
--- @param time number      Time (usually in seconds)
--- @param bpm number       BPM value, defaults to 100.
--- @return number
function TimeUtil.timeToBeat(time, bpm)
    time = time or 0.0
    bpm = bpm or 100.0
    return (time * bpm) / 60.0
end

--- Transforms a row into a beat.
---
--- this is normally not in FNF but idc.
--- @param row number row number.
--- @param rowsPerBeat? number amount of rows in a beat, defaults to 48
--- @return number
function TimeUtil.rowToBeat(row, rowsPerBeat)
    row = row
    rowsPerBeat = rowsPerBeat or 48
    return row / rowsPerBeat
end

--- Transforms a beat into a row.
--- @param beat number beat number
--- @param rowsPerBeat? number amount of rows in a beat, defaults to 48
--- @return number
function TimeUtil.beatToRow(beat, rowsPerBeat)
    rowsPerBeat = rowsPerBeat or 48
    return math.round(beat * rowsPerBeat)
end

--- Makes a fake conductor which is used as a fallback if there's none in the current screen.
--- @param phBpm? number placeholder BPM value, defaults to 100.
--- @return table
function TimeUtil.makeFakeConductor(phBpm)
    phBpm = phBpm or 100.0
    return {
        bpm = phBpm,                     --- @type number
        crotchet = (60 / phBpm),         --- @type number
        semiquaver = (60 / phBpm) * 4.0, --- @type number
        time = 0.0,                      --- @type number
        step = 0.0,                      --- @type number
        beat = 0.0,                      --- @type number
    }
end

return TimeUtil
