local ModuleManager = Class()

function ModuleManager:init()
    self.modules = {}
    return self
end

function ModuleManager:loadModule(file)
    file = string.gsub(file, "%.", "/")
    if love.filesystem.getInfo(file) then
        local name = string.sub(file, 1, -5)
        local mod, err = love.filesystem.load(file)
        if err then
            print(err)
            return
        end
        self.modules[name] = mod
    end
end

function ModuleManager:loadModulesAtPath(path)
    path = string.gsub(path, "%.", "/")
    for _, v in pairs(love.filesystem.getDirectoryItems(path)) do
        local module, err = love.filesystem.load(path .. "/" .. v)
        if err then
            print(err)
            return
        end
        self.modules[string.sub(v, 1, -5)] = module
    end
end

function ModuleManager:run()
    for k, _ in pairs(self.modules) do
        --print("executing \""..k.."\" module")
        self.modules[k]()
    end
end

return ModuleManager
