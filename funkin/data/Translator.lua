local Translator = {
	localeData = {}
}

local DEFAULT_LOCALE = "en"

function Translator.getLocaleList()
	local _list = {}
	local _files = love.filesystem.getDirectoryItems("assets/data/locale")
	for idx,asset in pairs(_files) do
		table.insert(_list,idx,asset)
	end
	return _list
end

function Translator.parseFile(file, change)
	if change == nil then change = true end
	if love.filesystem.getInfo(file) == nil then
		print("Failed to parse language file \""..file.."\" because the file couldn't be loaded.")
		return
	end
	local inip = require("jigw.lib.inifile")
	local data = inip.parse(file,"love")
	if change == true then Translator.localeData = data end
	return data
end

function Translator.getString(name,page,...)
	local t = Translator.localeData[page][name]
	if string.first(t,'"') and string.last(t,'"') then
		t = t:sub(2,#t-1)
	end
	local replacements = ... or {}
	if #replacements ~= 0 then
	  for i=1, #replacements do
			--print("replacing {"..i.."} with "..tostring(replacements[i]))
			t = string.gsub(t,"{"..i.."}",tostring(replacements[i]))
	  end
	end
	if t then return t end
	return "TRANSLATION MISSING "..name.." IN PAGE "..page
end

return Translator