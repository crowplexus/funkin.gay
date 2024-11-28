--- A handler for localization, includes function to capture strings from translation files.
---
--- Files must be in the ini format, and contain at least one default category, with two default values
--- i.e:
---
--- ```ini
--- [lang]
--- name="English"
--- author="Me, Myself, and I"
---
--- regularPluralPrefix=""
--- regularPluralSuffix="s"
--- ```
local Translator = {
	localeData = {},
	localeName = "Unknown",
	localeAuthor = "Unknown",
	availableLocales = {},
}

local DEFAULT_LOCALE = "en"
local _localeFilePath = Paths.getPath("data/locale")


--- Parses a translation file and loads it if allowed;
---
--- If the file does not exist, returns an empty table.
--- @param file string				File path.
--- @param change boolean			If the translator should immediately apply the translation (if successful)
--- @return string, string, table
local function parseFile(file, change)
	change = change or false
	if love.filesystem.getInfo(file) == nil then
		print("Failed to parse locale file \"" .. file .. "\" because the file couldn't be loaded.")
		return "Unknown", "unknown", {}
	end
	local inip = require("jigw.lib.inifile")
	local data = inip.parse(file, "love")
	local n = data.lang.name or "Unknown"
	local a = data.lang.author or "Unknown"

	if change == true then
		Translator.localeData = data
		if string.first(n, '"') and string.last(n, '"') then n = n:sub(2, #n - 1) end
		if string.first(a, '"') and string.last(a, '"') then a = a:sub(2, #a - 1) end
		Translator.localeName = n
		Translator.localeAuthor = a
	end
	return n, a, data
end

--- Initialises the translator.
---
--- @param locale? string		Language to use by default.
function Translator.init(locale)
	Translator.availableLocales = Translator.getLocaleList(_localeFilePath)
	if locale then
		Translator.changeLocale(locale)
	else
		if #Translator.localeData == 0 then
			Translator.resetLocale()
		end
	end
end

--- Sets the current locale to the default one immediately.
function Translator.resetLocale()
	Translator.changeLocale(DEFAULT_LOCALE)
end

--- Changes the current locale.
---
--- @param newloc string			Locale to change to.
function Translator.changeLocale(newloc)
	newloc = string.gsub(string.lower(newloc), " ", "-") -- format filename
	if Translator.availableLocales[newloc] == nil then
		print("Error when changing locale - locale unavailable: " .. newloc)
		-- avoiding a crash
		if #Translator.localeData == 0 then
			print("No locale loaded! Resetting to default...")
			Translator.resetLocale()
		end
		return
	end
	local n, _, _ = parseFile(_localeFilePath .. "/" .. Translator.availableLocales[newloc], true)
	if n then print("Changed locale to " .. n) end
end

--- Returns a list of locale files in a given folder.
--- @param path string path where your localfd files are, files must be in .ini format
--- @return table
function Translator.getLocaleList(path)
	local _list = {}
	local _files = love.filesystem.getDirectoryItems(path)
	for _, asset in pairs(_files) do
		_list[string.gsub(string.lower(asset), ".ini", "")] = asset
	end
	return _list
end

local function applyReps(str, replacements)
	if #replacements == 0 then
		return str
	end
	for i = 1, #replacements do
		--print("replacing {"..i.."} with "..tostring(replacements[i]))
		str = string.gsub(str, "{" .. i .. "}", tostring(replacements[i]))
	end
	return str
end

--- `tr` but with no error handling whatsoever.
---
--- @see Translator.tr
---
--- @param name string							String name to capture.
--- @param category? string						Category to capture the string from, if unspecified, tries to search on the global scope, may result in nil
--- @param replacements? table<string>			If your string has placeholders (i.e: {1}, {2}) those will get replaced by these elements
--- @return string
local function trUns(name, category, replacements)
	local v = Translator.localeData[category][name] or "nil"
	v = applyReps(v, replacements)
	return tostring(v)
end

--- Grabs a string from the currently loaded translation file.
---
--- if the string is nil, this will return another string, containing details of what tried to be captured by this function.
--- @param name string							String name to capture.
--- @param category? string						Category to capture the string from, if unspecified, tries to search on the global scope, may result in nil
--- @param replacements? table<string>			If your string has placeholders (i.e: {1}, {2}) those will get replaced by these elements
--- @return string
function Translator.tr(name, category, replacements)
	category = category or "lang"
	replacements = replacements or {}

	local t = trUns(name, category, replacements)
	if t and t ~= "nil" then
		if string.first(t, '"') and string.last(t, '"') then
			t = t:sub(2, #t - 1)
		end
		return t
	else
		return "TRANSLATION MISSING \"" ..
			name .. "\"" .. (#category ~= 0 and " IN \"" .. category .. "\" CATEGORY" or "")
	end
end

return Translator
