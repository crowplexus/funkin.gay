local Script = require("funkin.backend.scripting.Script")
local ScriptsHandler = Classic:extend("ScriptsHandler") --- @class ScriptsHandler

function ScriptsHandler:construct()
    ---@type table <Script> holds instances of active lua scripts
    self.scripts = {}
end

---loads a script from it's path
---@param tag any
---@param path any
function ScriptsHandler:loadScript(tag, path)
    self.scripts[tag] = Script(path)
end

function ScriptsHandler:loadDirectory(...)
    for _, directory in ipairs({ ... }) do
        print(directory)
        for _, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
            if file:last('.lua') then
                self:loadScript(directory .. "/" .. file, directory .. "/" .. file)
            end
        end
    end
end

---gets a script from its tag
---@param tag string
---@return Script
function ScriptsHandler:getScript(tag)
    return self.scripts[tag]
end

---gets all the values for a variable across every script instance
---@param key string
---@return table <any>
function ScriptsHandler:get(key, removeNil)
    local list = {}

    for _, script in pairs(self.scripts) do
        local value = script:get(key)
        if value == nil and removeNil == true then
            table.insert(list, value)
        end
    end

    return list
end

---sets a variable active
---@param key string
---@param value any
function ScriptsHandler:set(key, value)
    for _, script in pairs(self.scripts) do
        script:set(key, value)
    end
end

function ScriptsHandler:call(key, ...)
    for _, script in pairs(self.scripts) do
        script:call(key, ...)
    end
end

function ScriptsHandler:close()
    for _, script in pairs(self.scripts) do
        script:close()
    end
    self.scripts = nil
end

return ScriptsHandler
