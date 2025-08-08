-- lua/my_snacks_plugins.lua
local M = {}

local vim_plug_home = vim.g.plug_home or (vim.fn.stdpath('data') .. '/plugged')
local nvim_pack_path = vim.fn.stdpath('data') .. '/site/pack/core/opt'

local function resolve_plugin_path(bang)
  if bang and vim.fn.isdirectory(nvim_pack_path) == 1 then
    return nvim_pack_path
  else
    return vim_plug_home
  end
end

local function plugin_items(dir)
  local result = {}
  for _, path in ipairs(vim.fn.glob(dir .. '/*', true, true)) do
    if vim.fn.isdirectory(path) == 1 then
      result[#result + 1] = {
        text = vim.fn.fnamemodify(path, ':t'),
        file = path,
      }
    end
  end
  return result
end

-- show a list of plugin directories, then hand off cwd+filter to `picker_fn`
local function pick_plugin_dir(picker_fn, bang)
  Snacks.picker.pick({
    title = 'Choose plugin…',
    items = plugin_items(resolve_plugin_path(bang)),
    format = function(entry)
      return { { entry.text } }
    end,
    confirm = function(_, entry)
      -- only vim or lua files inside that plugin
      local filter_fn = function(candidate)
        return candidate.file:match('%.vim$') or candidate.file:match('%.lua$')
      end
      picker_fn({
        cwd = entry.file,
        filter = filter_fn,
      })
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
