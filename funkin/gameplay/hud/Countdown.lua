--- Handles the pre-gameplay countdown
--- @class funkin.gameplay.hud.Countdown
local Countdown = {
    silent = false,
    finished = false,
    progress = 1,
}
local Conductor = require("funkin.backend.Conductor")
local PopupSprite = require("funkin.gameplay.hud.PopupSprite")

local spritePaths = {}
local soundPaths = {}
local parent = nil

--- Resets all values to their defaults
---
--- @param par      any Parent screen, can be nil, this is where the sprite gets added
function Countdown.reset(par)
    Countdown.silent = false       --- @type boolean
    Countdown.startCallback = nil  --- @type function
    Countdown.finishCallback = nil --- @type function
    Countdown.spriteCreated = nil  --- @type function
    Countdown.soundCreated = nil   --- @type function
    Countdown.progress = 1         --- @type number
    -- set default sprites and sounds
    Countdown.setSprites(nil)
    Countdown.setSounds(nil)
    parent = par
end

--- Changes the countdown sprite paths
---
--- @usage `Countdown.setSprites({ "play/countdown/prepare.png", "play/countdown/ready.png", "play/countdown/set.png", "play/countdown/go.png" })`
function Countdown.setSprites(tbl)
    spritePaths = tbl or {
        "play/countdown/prepare.png",
        "play/countdown/ready.png",
        "play/countdown/set.png",
        "play/countdown/go.png",
    }
end

--- Changes the countdown sound paths
---
--- @usage `Countdown.setSounds({ "play/countdown/sfx/three.ogg", "play/countdown/sfx/two.ogg", "play/countdown/sfx/one.ogg", "play/countdown/sfx/go.ogg" })`
function Countdown.setSounds(tbl)
    soundPaths = tbl or {
        "play/countdown/sfx/three.ogg",
        "play/countdown/sfx/two.ogg",
        "play/countdown/sfx/one.ogg",
        "play/countdown/sfx/go.ogg",
    }
end

--- Starts the countdown from zero
---
--- it is recommended to call `Countdown.reset` before doing this.
function Countdown.start(silent)
    if Countdown.progress > #soundPaths then
        print("Countdown progress is above " .. #soundPaths .. ", please reset it, aborting")
        return
    end
    Countdown.silent = silent or false
    if Countdown.startCallback then
        Countdown.startCallback()
    end
    Timer.create(Conductor.getCurrent().crotchet, function()
        Countdown.displaySprite(Countdown.progress)
        if not Countdown.silent then
            Countdown.playSound(Countdown.progress)
        end
        --print("progress " .. Countdown.progress)
        Countdown.progress = Countdown.progress + 1
        if Countdown.progress > #soundPaths + 1 and Countdown.finishCallback then
            Countdown.finishCallback()
        end
    end, #soundPaths, true)
end

function Countdown.playSound(id)
    id = id or 1
    if id > #soundPaths or silent then
        return
    end
    local countdownSound = Paths.getSound(soundPaths[id])
    if countdownSound ~= nil then
        countdownSound:setVolume(0.5)
        countdownSound:play()
        if Countdown.soundCreated then
            Countdown.soundCreated()
        end
        Timer.create(countdownSound:getDuration("seconds"), function()
            countdownSound:release()
        end, 0)
    end
end

function Countdown.displaySprite(id)
    id = id or 1
    if id > #spritePaths or parent == nil then
        return
    end
    local countdownSprite = PopupSprite(0, 0, Paths.getImage(spritePaths[id]))
    countdownSprite:centerPosition(Axis.XY)
    countdownSprite.acceleration.y = 300
    countdownSprite.velocity.y = countdownSprite.velocity.y - 130
    countdownSprite.scale.x = 0.8
    countdownSprite.scale.y = 0.8
    countdownSprite.moving = true
    if Countdown.spriteCreated then
        Countdown.spriteCreated(countdownSprite)
    end
    if parent and parent.add then parent:add(countdownSprite) end

    local ctime = Conductor.getCurrent().crotchet
    Timer.create(ctime + 0.001, function()
        countdownSprite:dispose()
    end)
    Tween.create(ctime, countdownSprite, { alpha = 0.0 }, "inOutCubic")
end

return Countdown
