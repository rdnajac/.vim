local M = {}

local is_dict_like = function(v) -- has string and number keys
  return type(v) == 'table' and (vim.tbl_isempty(v) or not svim.islist(v))
end
local is_dict = function(v) -- has only string keys
  return type(v) == 'table' and (vim.tbl_isempty(v) or not v[1])
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type
---@generic T
---@param ... T
---@return T
function M.merge(...)
  local ret = select(1, ...)
  for i = 2, select('#', ...) do
    local value = select(i, ...)
    if is_dict_like(ret) and is_dict(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    elseif value ~= nil then
      ret = value
    end
  end
  return ret
end

--- Get an example config from the docs/examples directory.
---@param snack string
---@param name string
---@param opts? table
function M.example(snack, name, opts)
  local path = vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim', 'docs', 'examples', snack .. '.lua')
  local ok, ret = pcall(function()
    return loadfile(path)().examples[name] or error(('`%s` not found'):format(name))
  end)
  if not ok then
    Snacks.notify.error(('Failed to load `%s.%s`:\n%s'):format(snack, name, ret))
  end
  return ok and vim.tbl_deep_extend('force', {}, vim.deepcopy(ret), opts or {}) or {}
end

---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
function M.get(snack, defaults, ...)
  local merge, todo = {}, { defaults, M[snack] or {}, ... }
  for i = 1, select('#', ...) + 2 do
    local v = todo[i] --[[@as snacks.Config.base]]
    if type(v) == 'table' then
      if v.example then
        table.insert(merge, vim.deepcopy(M.example(snack, v.example)))
        v.example = nil
      end
      table.insert(merge, vim.deepcopy(v))
    end
  end
  local ret = M.merge(unpack(merge))
  if type(ret.config) == 'function' then
    ret.config(ret, defaults)
  end
  return ret
end

--- Register a new window style config.
---@param name string
---@param defaults snacks.win.Config|{}
---@return string
function M.style(name, defaults)
  M.styles[name] = vim.tbl_deep_extend('force', vim.deepcopy(defaults), M.styles[name] or {})
  return name
end

return M
