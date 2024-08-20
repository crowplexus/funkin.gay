local class = {
  __name = "Class"
}
class.__index = class

--- This will clone a class' functions and variables
--- and move them to the target table.
--- @type function
--- @param target table   I wonder what this means...
--- @param ... any        Classes to clone methods and properties from.
function class:clone(target, ...)
  local to_clone = {...}
  for _,um_uhhhh_erm in ipairs(to_clone) do
    setmetatable(target, um_uhhhh_erm)
    print(_)
  end
end

return class
