--  {{cookiecutter.proj_name}}.lua -*- mode: lua-mode -*-
--  Summary:
--
--  Tags:
--
local getlocal    = require("debug" ).getlocal
local texio       = require("texio")

-- Consts:

-- Base class and its data:
local TheObject = {
  total           =  {},
  changes         =  {},
  fluents         =  {},
  count           = -1,
  dir             = "below",
  dist            = "1cm",
  side            = "left",
  WRITE_DEBUG     = false,
  catcode         = -1,
  last_prefix     = nil
}

local function debug(str, ...)
  -- Writes out debug information when the package is loaded with the debug option
  local val
  if EventChain.WRITE_DEBUG ~= true then return end
  if ... then
    val = string.format(str, ...)
  else
    val = str
  end
  texio.write_nl("term", "-- EventChain --: "  .. val .. "\n")
end

function TheObject:new ()
  -- ctor for an eventchain. Takes a direction, a node distance
  debug("Creating object")
  o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function TheObject:output (...)
  -- Util method to output strings to the tex file for expansion.
  local extra = table.pack(...)
  ::loop:: for i,v in ipairs(extra) do
    if v == nil then goto loop end
    table.insert(self.total, v)
    tex.print(v)
  end
end

-- Provide the class:
return EventChain
