local git_status = require('lazy.spec.oil.git_status')
local git_status_cache = git_status.new()

local M = { 'stevearc/oil.nvim' }

M.dependencies = { 'refractalize/oil-git-status.nvim' }

M.opts = function()
  vim.keymap.set('n', '-', function()
    require('oil').open_float()
  end, { desc = 'Open Oil in float' })

  vim.keymap.set('n', '_', function()
    require('oil').open()
  end, { desc = 'Open Oil in current window' })

  require('lazy.spec.oil.autocmds')
  -- LazyVim.on_very_lazy(function()
  --   require('lazy.spec.oil.git_extmarks')
  -- end)

  local refresh = require('oil.actions').refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status_cache = git_status.new()
    orig_refresh(...)
  end

  ---@type oil.setupOpts
  return {
    default_file_explorer = true,
    -- skip_confirm_for_simple_edits = true,
    constrain_cursor = 'name',
    watch_for_changes = true,
    keymaps = require('lazy.spec.oil.keymaps'),

    float = {
      padding = 2, -- default = `2`
      -- border = 'none', -- default - `rounded`
      win_options = {
        -- no line numbers
        signcolumn = 'yes:2',
        winblend = 0,
      },
      get_win_title = nil,
      -- peview_split = 'right',
      override = function(conf)
        conf.row = 1 -- assuming we have tabline
        return conf
      end,
    },

    view_options = {
      is_hidden_file = function(name, bufnr)
        local dir = require('oil').get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, '.')

        if not dir then
          return is_dotfile
        end

        if is_dotfile then
          return not git_status_cache[dir].tracked[name]
        end
        return false
      end,

      is_always_hidden = function(name, _)
        return name == '../'
      end,
    },
  }
end

return M
