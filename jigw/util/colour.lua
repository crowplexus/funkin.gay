return {
  BLACK           = 0xFF000000,
  WHITE           = 0xFFFFFFFF,
  RED             = 0xFFFF0000,
  GREEN           = 0xFF00FF00,
  BLUE            = 0xFF0000FF,
  YELLOW          = 0xFFFFFF00,
  ORANGE          = 0xFFFF8000,
  CYAN            = 0xFF00FFFF,
  PINK            = 0xFFFFC0CB,
  BROWN           = 0xFFA52A2A,
  MAGENTA         = 0xFFFF00FF,
  LAVENDER        = 0xFFE6E6FA,
  INDIGO          = 0xFF4B0082,
  GREEN_YELLOW    = 0xFFADFF2F,
  PALE_GREEN      = 0xFF98FB98,

  rgba_table = function(r,g,b,a)
    if a == nil or type(a) ~= "number" then
      a = 255
    end
    return {r,g,b,a}
  end,
}
