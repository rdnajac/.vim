local git_status = require('lazy.spec.oil.git_status')
local git_status_cache = git_status.new()

return {
  'stevearc/oil.nvim',
  enabled = true,
  lazy = false,
  keys = {
    { '-', '<Cmd>Oil<CR>' },
    { '_', '<Cmd>Oil --float<CR>' },
    -- { '<leader>e', '<Cmd>Oil<CR>' },
    -- { '<leader>e', '<Cmd>topleft 30vsplit +Oil<CR>' },
  },
  opts = function()
    local refresh = require('oil.actions').refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status_cache = git_status.new()
      orig_refresh(...)
    end

    LazyVim.on_very_lazy(function()
      require('lazy.spec.oil.autocmds')
    end)

    ---@type oil.setupOpts
    return {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      constrain_cursor = 'name',
      watch_for_changes = true,
      keymaps = require('lazy.spec.oil.keymaps'),

      float = {
        padding = 2, -- default = `2`
        -- border = 'none', -- default - `rounded`
        border = 'rounded', -- default - `rounded`
        win_options = {
          winblend = 0,
        },
        get_win_title = nil,
        -- peview_split = 'right',
        override = function(conf)
          conf.row = 1 -- assuming we have tabline
          -- conf.width = 30
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

      preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        -- preview_method = 'load',
      },
    }
  end,
}
