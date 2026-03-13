local M = {}

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
  local scope = opts.scope or 'g'
  vim[scope][opts.name] = vim[scope][opts.name] ~= nil and vim[scope][opts.name]
    or opts.default
    or 1

  local toggle = Snacks.toggle.new({
    name = opts.label or opts.name:gsub('_', ' '):gsub('^%l', string.upper),
    get = function()
      local val = vim[scope][opts.name]
      return val == '1' or val == 1 or val == true
    end,
    set = function(state) vim[scope][opts.name] = state and 1 or 0 end,
  })
  if opts.mapping then
    M.register({ [opts.mapping] = function() return toggle end })
  end
  return toggle
end

return M
