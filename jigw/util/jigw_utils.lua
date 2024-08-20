return {
    --- @param x number number of bytes to format.
    --- @param digits? number number of digits on the returning string, defaults to 2.
    --- @return string
    format_bytes = function(x, digits)
        if digits == nil or type(digits) ~= "string" then
            digits = 2
        end
        local units = {"B", "kB", "MB", "GB", "TB", "PB"}
        local unit = 3
        while x >= 1024 and unit < #units do
            x = x / 1024
            unit = unit + 1
        end
        return string.format("%."..digits.."f", x)..units[unit]
    end,
    --- fake match/switch for lua
    match = function(prop, pat)
      return pat[prop] ~= nil and pat[prop]() or pat.default ~= nil and pat.default()
  end,
}
