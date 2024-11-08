--- A handler for localization, includes function to capture strings from translation files.
---
--- Files must be in the ini format, and contain at least one default category, with two default values
--- i.e:
---
--- ```ini
--- # [Data] or [data] is a default category name
--- [Data]
--- name="English"
--- author="Me, Myself, and I"
--- ```
local Translator = {
	localeData = {},
	languageName = "Unknown",
	languageAuthor = "Unknown",
}

local DEFAULT_LOCALE = "en"

--- Returns a list of locale files in a given folder.
--- @param path string path where your locale files are, files must be in .ini format
--- @return table
function Translator.getLocaleList(path)
	local _list = {}
	local _files = love.filesystem.getDirectoryItems(path)
	for idx,asset in pairs(_files) do
		table.insert(_list,idx,asset)
	end
	return _list
end

--- Parses a translation file and loads it if allowed;
---
--- If the file does not exist, returns an empty table.
--- @param file string				File path.
--- @param change boolean			If the translator should immediately apply the translation (if successful)
--- @return table
function Translator.parseFile(file, change)
	if change == nil then change = true end
	if love.filesystem.getInfo(file) == nil then
		print("Failed to parse language file \""..file.."\" because the file couldn't be loaded.")
		return {}
	end
	local inip = require("jigw.lib.inifile")
	local data = inip.parse(file,"love")
	if change == true then
		Translator.localeData = data
		local n = data.Data.name or data.data.name or "Unknown"
		local a = data.Data.author or data.data.author or "Unknown"
		if string.first(n,'"') and string.last(n,'"') then n = n:sub(2,#n-1) end
		if string.first(a,'"') and string.last(a,'"') then a = a:sub(2,#a-1) end
		Translator.languageName = n
		Translator.languageAuthor = a
	end
	return data
end

--- Grabs a string from the currently loaded translation file.
---
--- if the string is nil, this will return another string, containing details of what tried to be captured by this function.
--- @param name string										String name to capture.
--- @param category string								Category to capture the string from, if unspecified, tries to search on the global scope, may result in nil
--- @param replacements table<string>			If your string has placeholders (i.e: {1}, {2}) those will get replaced by these elements
--- @return string
function Translator.getString(name,category,replacements)
	local t = Translator.localeData[category][name] or Translator.localeData[name]
	if t ~= nil then
		if string.first(t,'"') and string.last(t,'"') then
			t = t:sub(2,#t-1)
		end
		if #replacements ~= 0 then
		  for i=1, #replacements do
				--print("replacing {"..i.."} with "..tostring(replacements[i]))
				t = string.gsub(t,"{"..i.."}",tostring(replacements[i]))
		  end
		end
		return t
	end
	return "TRANSLATION MISSING \""..name.."\" IN \""..category.."\" CATEGORY"
end

return Translator