---@brief
---
--- Simple class demo using metatables.
---
--- ```lua
--- local M = require('class')
--- local obj = M.new('foo', 42)
--- print(obj:greet())          -- "Hello from foo!"
--- print(tostring(obj))        -- "M(foo, 42)"
--- local merged = obj:merge(M.new('bar', 8))
--- print(tostring(merged))     -- "M(foo+bar, 50)"
--- ```

---@class M
---@field name string
---@field value number
local M = {}
M.__index = M

---@param name string
---@param value number
---@return M
function M.new(name, value) return setmetatable({ name = name, value = value }, M) end

function M:__tostring() return ('M(%s, %d)'):format(self.name, self.value) end

---@return string
function M:greet() return ('Hello from %s!'):format(self.name) end

---@param other M
---@return M
function M:merge(other) return M.new(self.name .. '+' .. other.name, self.value + other.value) end

return M
