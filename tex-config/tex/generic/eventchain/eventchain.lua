-- --  simpletikz.lua -*- mode: lua -*-
local getlocal    = require("debug" ).getlocal
local texio       = require("texio")

local EventChain  = {
  total   =  {},
  changes =  {},
  fluents =  {},
  count   = -1,
  dir     = "below",
  dist    = "1cm",
  side    = "left"
}

local DIRECTIONS  = {["left"]=1, ["right"]=1, ["above"]=1, ["below"]=1}
local OPPOSITE    = {["left"]="right", ["right"]="left", ["above"]="below", ["below"]="above"}
local BEGIN       = [[\begin]]
local END         = [[\end]]
local NODE        = [[\node]]
local OBRACE      = "{"
local CBRACE      = "}"
local LDOTS       = [[\ldots]]
local EMPTYSET    = [[\emptyset{}]]
local DRAW        = [[\draw]]
local EMPH        = [[\emph]]
local BOTTOM      = [[$\bot$]]
local TOP         = [[$\top$]]
local TURNSTILE   = [[$\vdash$]]
local ENDSTILE    = [[$\dashv$]]

-- --  --------------------------------------------------

local function debug(str, ...)
  local val
  if ... then
    val = string.format(str, ...)
  else
    val = str
  end
  texio.write_nl("term", "-- EventChain --: "  .. val .. "\n")
end

function EventChain:collect (...)
  local extra = table.pack(...)
  for i,v in ipairs(extra) do
    -- for m in string.gmatch(v, "[^\n]+") do
    --   table.insert(self.total, m)
    --   tex.print(m)
    -- end
    table.insert(self.total, v)
    tex.print(v)
  end
end


-- --  --------------------------------------------------

function EventChain:new (dir, dist, start)
  debug("Creating Eventchain: (%s), (%s), (%s)", dir, dist, start)
  o = {}
  setmetatable(o, self)
  self.__index = self
  if dir ~= nil and string.len(dir) > 0 then self.dir = dir end
  if dist ~= nil and string.len(dist) > 0 then self.dist = dist end

  if self.dir == "right" then self.side = "above" end

  debug("Start: %s", start)
  self:open(start)
  return o
end

function EventChain:open (start)
  debug("Open: %s : %s, %s", self.dir, self.dist, start)
  local chain_str = string.format("start chain=trace going %s", self.dir)
  local node_str = string.format("node distance=%s and %s", self.dist, self.dist)
  local style_str = string.format("every node/.style={%s}", [[draw, circle, font=\tiny]])

  self:collect(
    string.format("%s{longtable}{@{}l@{}}", BEGIN),
    string.format("%s{tikzpicture}[%s, %s, %s]",
                  BEGIN, chain_str, node_str, style_str),
    "% Chain Starts here: "
  )
  self:start(start)
end

function EventChain:close ()
  debug("Close")
  self:finish()
  self:collect(
    "% Chain Ends here",
    END .. "{tikzpicture}",
    END .. "{longtable}"
    )
  local final = table.concat(self.total, "\n")
  debug("Final: ")
  debug("\n" .. final)
  self.total = {}
  return nil
end

function EventChain:start (val)
  debug("Start event: %s", val or -1)
  self:set_count(val or 0)
  local start_sym = TOP
  if self.dir == "right" then start_sym = TURNSTILE end

  self:collect(
    OBRACE,
    "% start node",
    string.format("%s [on chain=trace, join] (%s) { %s } ;",
                  NODE, self:node_id(),
                  -- self:node_content(),
                  start_sym
                  ),
    CBRACE
  )
  self:tick()
end

function EventChain:node (val)
  debug("Basic Node: %s", val or 'nil')
  local curr_count = self.count
  self:set_count(val)
  if curr_count ~= self.count then
    debug("Jumping to")
    self:continue()
  end

  self:collect(
    string.format("%s [on chain=trace, join] (%s) { %s } ;",
                  NODE, self:node_id(), self:node_content(val))
  )
  self:tick()

end

function EventChain:continue (val)
  debug("Continue Node: %s", val)
  self:collect(
    OBRACE,
    "% continuing",
    string.format("%s [on chain=trace, join, draw=none] (%s) { %s };",
                  NODE, self:node_id(), LDOTS),
    CBRACE
    )
  self:set_count(val)
end

function EventChain:finish ()
  debug("Finish Node")
  local end_sym = BOTTOM
  if self.dir == "right" then end_sym = ENDSTILE end

  self:collect(
    OBRACE,
    "% end node",
    string.format("%s [on chain=trace, join] (%s) { %s } ;",
                  NODE, self:node_id(-1),
                  end_sym
    ),
    CBRACE
  )
end

function EventChain:change_open(name, dist)
  name = name or "Ev:"
  debug("Opening Changes: %s, %s", name, dist)

  self:collect(
    -- Continue the Chain
    -- OBRACE,
    "% opening changes",
    string.format("%s [on chain=trace, shape=diamond] (mid_%s) {};",
                  NODE, self:node_id()),
    string.format("%s [on chain=trace] (%s) { %s };",
                  NODE, self:node_id(), self:node_content()),
    string.format("%s (%s) -- (mid_%s);",
                  DRAW, self:node_id(self:prev_tick()), self:node_id()),
    string.format("%s (mid_%s) -- (%s);",
                  DRAW, self:node_id(), self:node_id())
    -- CBRACE
    )
  -- And add the changed fluents to the side
  opp = OPPOSITE[self.dir]
  options = string.format("-latex, shape=rectangle, %s=%s",
                          self.side, dist)
  self:collect(
    -- OBRACE,
    string.format("%s (mid_%s) node[ %s ] (text_%s)",
                  DRAW, self:node_id(), options,
                  self:node_id(self:prev_tick())),
    string.format("%s %s{tabular}{l}", OBRACE, BEGIN),
    string.format([[%s{%s}: \\]], EMPH, name)
  )
end

function EventChain:change_close ()
  self:collect(
    string.format("%s{tabular} %s;", END, CBRACE),
    string.format("%s (mid_%s) --  (text_%s);",
                  DRAW, self:node_id(), self:node_id(self:prev_tick())
    ),
    "% Closing changes"
    -- CBRACE
  )
  self:tick()
  self.side = OPPOSITE[self.side]

  debug("Changes closed")
end

function EventChain:fluents_open (name, dist)
  debug("Opening Fluents: %s, %s", name, dist)
  self:node()
  local options = string.format("-latex, shape=rectangle, rounded corners, %s=%s",
                                self.side, dist)
  self:collect(
    OBRACE,
    "% Open Fluents",
    string.format("%s (%s) node[%s] (fluents_%s) ",
                  DRAW, self:node_id(self:prev_tick()),
                  options,
                  self:node_id(self:prev_tick())
    ),
    string.format("%s %s{tabular}{ l c }", OBRACE, BEGIN),
    string.format([[%s{%s}: \\]], EMPH, name)
    )
end

function EventChain:fluents_close ()
  self:collect(
    string.format("%s{tabular} %s; ", END, CBRACE),
    string.format("%s (%s) -- (fluents_%s);",
                  DRAW,
                  self:node_id(self:prev_tick()),
                  self:node_id(self:prev_tick())),
    CBRACE
    )

  self.side = OPPOSITE[self.side]
end

function EventChain:node_id (val)
  local id = self.count
  if val ~= nil then
    id = val
  end
  return string.format("trace_%s", id)
end

function EventChain:node_content (val)
  local id = self.count
  if val ~= nil and val ~= "nil" and string.len(val) > 0 then id = val end
  return string.format("$ S_{%s} $", id)
end

function EventChain:set_count(val)
  if val == "nil" or val == nil or string.len(val) == 0 then
    debug("Set count early exit: %s", val)
    return
  end

  self.count = tonumber(val)
  debug("Set count to: %s", self.count)
end

function EventChain:tick()
  self.count = math.floor(self.count + 1)
end

function EventChain:prev_tick ()
  return math.floor(self.count - 1)
end

-- --  --------------------------------------------------
return EventChain
