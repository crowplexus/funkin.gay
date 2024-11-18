local NoteSpawner = Classic:extend("NoteSpawner")
local NoteObject = require("funkin.gameplay.note.NoteObject")
local AnimatedSprite = require("jigw.objects.AnimatedSprite")

local _alloc = 0
local _drawable = nil
local _current = 1

--- @param totalNotes number        How many notes are allowed to be spawned.
function NoteSpawner:construct(totalNotes)
    _alloc = totalNotes
    _drawable = AnimatedSprite(640, 360)
    _drawable:loadAtlas(Paths.getPath("play/notes/normal/notes"), {
        { "tap", "blue tap", 0, false },
    })
    _drawable:playAnimation("tap", true)
end

--- @param totalNotes number        How many notes are allowed to be spawned.
function NoteSpawner:reset(totalNotes)
    totalNotes = totalNotes or _alloc
    _current = 1
    if _alloc ~= totalNotes then
        _alloc = totalNotes
    end
end

function NoteSpawner:spawnCycle()
    -- this shouldn't happen?
    if _current > _alloc then
        return
    end
    _current = _current + 1
end

function NoteSpawner:draw()
    if _drawable and _drawable.draw then
        _drawable:draw()
    end
end

return NoteSpawner
