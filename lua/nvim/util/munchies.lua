local M = {}

function M.bench(fn, opts)
  opts = opts or {}
  if not opts.title then
    local info = debug.getinfo(fn, 'n')
    opts.title = info.name or tostring(fn)
  end
  print('Benchmarking: ' .. opts.title .. '(x' .. (opts.count or 100) .. ')')
  Snacks.debug.profile(fn, opts)
end

--- Create a toggleable Vim variable
--- @param opts table
---   name string: variable name without prefix
---   default boolean|number: default value (0/1 or false/true)
---   scope string?: optional scope ('g', 'b', 'w', etc.), default 'g'
---   mapping string?: optional key mapping
---   desc string?: optional description for the mapping
---   TODO: use snacks.toggle.Opts
--- @return snacks.toggle.Class
M.flag = function(opts)
  local name = opts.name
  local default = opts.default or 1
  local scope = opts.scope or 'g'
  local mapping = opts.mapping
  local desc = opts.desc or ('Toggle ' .. name)

  vim[scope][name] = vim[scope][name] ~= nil and vim[scope][name] or default

  local toggle = Snacks.toggle({
    name = opts.label or name:gsub('_', ' '):gsub('^%l', string.upper),
    get = function()
      local val = vim[scope][name]
      return val == '1' or val == 1 or val == true
    end,
    set = function(state) vim[scope][name] = state and 1 or 0 end,
  })
  if mapping then
    toggle:map(mapping, { desc = desc })
  end
  return toggle
end

return M
