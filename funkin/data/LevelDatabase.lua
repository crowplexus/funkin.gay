local LevelDatabase = {
	workingDir = "assets/data", --- @type string
	levels = {}, --- @type table
}

function LevelDatabase:clear()
	self.workingDir = "assets/data"
	self.levels = {}
end

function LevelDatabase:setWorkingDirectory(new)
	self.workingDir = new or "assets/data"
	return self.workingDir
end

function LevelDatabase:getLevels()
	local wd = self.workingDir
	if wd:last("/") then
		wd = string.sub(wd, 0, -2) -- i.e: "assets/data/levels"
	end
	local moddedLevel = require(wd .. "/modData.lua")
	moddedLevel:clear() -- should do this automatically BUT its here to be sure everything's good.
	moddedLevel:setWorkingDirectory("assets/data/levels")
	return LevelDatabase:deepPackSearch(packsToFind)
end

function LevelDatabase:deepPackSearch(packs)
	local levelsFound = {}
	local wd = self.workingDir
	if wd:last("/") then
		wd = string.sub(wd, 0, -2) -- i.e: "assets/data/levels"
	end

	local insertLevels = function(v)
		if not v then
			return
		end
		local p = wd .. "/" .. tostring(v) .. ".lua"
		if love.filesystem.getInfo(p) ~= nil then -- if its a script
			local module = p:gsub("/", ".")
			if module:last(".lua") then
				module = module:sub(1, #module - 4)
			end
			local vv = require(module)
			table.insert(levelsFound, vv)
		end
		if type(v) == "table" and v.id then -- if its a level table
			table.insert(levelsFound, v)
		end
	end

	for i, v in pairs(packs) do
		insertLevels(v)
		if type(v) == "table" and not v.id then
			for ii, vv in ipairs(v) do
				insertLevels(vv)
			end
		end
	end
	return levelsFound
end

return LevelDatabase
