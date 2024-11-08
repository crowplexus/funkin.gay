local classic = require("jigw.lib.classic")

local Script = classic:extend("Script") --- @class Script

-- NOT IMPLIMENTATION
local scriptENV = { Script = Script }

local trustedENV = { Script = Script }

local function blockFunction(name)
    return function()
        print("this script is not trusted, \"" .. name:upper() .. "\" is blocked")
    end
end

-- NOT IMPLIMENTATION
local deflect = {
    loadfile = blockFunction("loadfile")
}

for key, value in pairs(_G) do
    trustedENV[key] = value
end

local closedENV = {
    __index = function()
        error()
    end,
    __newindex = function()
        error()
    end
}

function Script:construct(path, trusted)
    self.vars = {}
    self.path = path
    self.failedFunctions = {}
    self.closed = false

    trusted = (trusted == nil and false or trusted)

    self.chunk = nil

    local status, err = pcall(function()
        local chunk, _err = love.filesystem.load(path)

        if type(chunk) ~= "function" then
            print(_err)
            self:close()
            return
        end

        -- this just uses the trustedENV for right now
        setfenv(chunk, setmetatable(self.vars, { __index = (trusted and trustedENV or trustedENV) }))

        self.vars.screen = ScreenManager.activeScreen -- instance of the current state

        chunk()

        self.chunk = chunk
    end)

    if not status then
        print("Script has failed to load: " .. err)
    end
end

function Script:get(key)
    return self.vars[key]
end

function Script:set(key, value)
    self.vars[key] = value
end

function Script:call(key, ...)
    if type(self.vars[key]) ~= "function" then return end
    if self.failedFunctions[key] then return end

    local status, err = pcall(self.vars[key], ...)

    if not status then
        self.failedFunctions[key] = true
        print("Error running function:" .. err)
    end
end

function Script:close()
    self.closed = true
    for key, value in ipairs({ "set", "get", "call" }) do
        self[value] = function() end
    end

    for key in next, self.vars do rawset(self.vars, key, nil) end
    if self.chunk then setfenv(self.chunk, closedENV) end

    self.vars = nil
    self.chunk = nil
end

return Script
