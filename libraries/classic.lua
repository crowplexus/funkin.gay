--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--


local Object = {}


function Object:new()
end


function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self --- @type metatable
  setmetatable(cls, self)
  return cls
end


function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end


function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


function Object:__tostring()
  return "Object"
end

function Object:__index(idx)
  -- custom get variable functionality
  return rawget(self,"get_"..idx) and rawget(self,"get_"..idx)() or rawget(self, idx) or Object[idx];
end

function Object:__newindex(idx,vl)
  -- custom set variable functionality
  if(rawget(self,"set_"..idx))then
    return rawget(self,"set_"..idx)(self,vl);
  end
  rawset(self, idx, vl);
end

function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

return Object
