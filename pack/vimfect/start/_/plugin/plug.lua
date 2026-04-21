--- Helper function to get plugin names for command completion.
---@param active boolean? filter by active/inactive plugins, or return all if nil
---@return string[] sorted list of plugin names
local function spec_names(active)
  local names = vim
    .iter(vim.pack.get())
    :filter(function(p) return active == nil or p.active == active end)
    :map(function(p) return p.spec.name end)
    :totable()
  table.sort(names)
  return names
end

local subcmds = {
  clean = function(args, _) vim.pack.del(args or spec_names(false)) end,
  get = function(args, bang) vim.pack.get(args, { info = bang }) end,
  status = function(args, bang) vim.pack.update(args, { offline = not bang }) end,
  update = function(args, bang) vim.pack.update(args, { force = bang }) end,
}

vim.api.nvim_create_user_command('Plug', function(opts)
  local subcmd = opts.fargs[1] or 'status'
  local args = #opts.fargs > 1 and vim.list_slice(opts.fargs, 2) or nil
  local fn = subcmds[subcmd]
  if fn then
    fn(args, opts.bang)
  else
    vim.notify('[Plug] bad subcommand: ' .. subcmd, vim.log.levels.ERROR)
  end
end, {
  nargs = '*',
  bang = true,
  complete = function(ArgLead, CmdLine, CursorPos)
    local args = vim.split(CmdLine, '%s+', { trimempty = true })
    local num_args = #args - (vim.endswith(CmdLine, ' ') and 0 or 1)

    -- first arg is subcommand
    if num_args == 1 then
      return vim
        .iter(vim.spairs(subcmds))
        :map(function(cmd, _) return vim.startswith(cmd, ArgLead) and cmd end)
        :totable()
    end

    -- second arg is (filtered) plugin names
    local subcmd = args[2]
    local loaded = subcmd == 'clean' and false or subcmd == 'status' and nil or true
    return subcmds[subcmd] and spec_names(loaded) or {}
  end,
})
