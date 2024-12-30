-- half baked HUD scripts
local TemplateHUD = require("game.scripting.hudskin")

-- Happens when the hud loads on the gameplay screen
function TemplateHUD:onHUDLoaded()
end

-- Happens when a receptor loads, you can also just load individual textures for each receptor here
-- that isn't recommended if we're talking performance - preferably, combine your images into one.
-- return `nil` to use a default icon
function TemplateHUD:onReceptorLoaded(receptor)
end

-- Happens during chart loading, to load textures for notetypes
-- return `nil` to use a default icon.
function TemplateHUD:onNoteLoaded(note)
end

-- Happens during chart loading, to load textures for note splashes
-- return `nil` to disable them.
function TemplateHUD:onSplashLoaded(splash)
    return nil
end

return TemplateHUD -- Don't forget this
