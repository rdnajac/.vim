if not vim.g.plug_home then
  vim.g.plug_home = vim.fn.stdpath('data')
end
-- lua/my_snacks_plugins.lua
local M = {}

local function plugins()
  local result = {}
  for path, type in vim.fs.dir(vim.g.plug_home) do
    if type == 'directory' then
      table.insert(result, {
        text = path,
        file = vim.fs.joinpath(vim.g.plug_home, path),
      })
    end
  end
  return result
end

-- show a list of plugin directories, then hand off cwd+filter to `picker_fn`
local function pick_plugin_dir(picker_fn, bang)
  Snacks.picker.pick({
    title = 'Choose plugin…',
    items = plugins(),
    format = function(entry)
      return { { entry.text } } -- no icons
    end,
    confirm = function(_, entry)
      -- only vim or lua files inside that plugin
      -- dd(entry)
      -- local filter_fn = function(candidate)
      --   return candidate.file:match('%.vim$') or candidate.file:match('%.lua$')
      -- end
      -- picker_fn({
      --   cwd = entry.file,
      --   filter = filter_fn,
      -- })
    end,
  })
end

-- merge the user’s own opts (e.g. bang) with what we got from pick_plugin_dir
local function make_picker(kind, user_opts)
  pick_plugin_dir(function(plugin_opts)
    local merged = vim.tbl_extend('force', user_opts or {}, plugin_opts)
    Snacks.picker[kind](merged)
  end, user_opts and user_opts.bang)
end

-- Create the two commands
function M.setup()
  local cmd = vim.api.nvim_create_user_command
  cmd('FindPlugin', function(ctx)
    make_picker('files', { bang = ctx.bang })
  end, { bang = true, nargs = '*', complete = 'file' })

  cmd('GrepPlugin', function(ctx)
    make_picker('grep', { bang = ctx.bang })
  end, { bang = true, nargs = '*', complete = 'file' })
end

M.setup()

return M
