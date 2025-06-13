local M = {}

local detail = 0
local git_status = require('lazy.spec.oil.git_status')
local git_status_cache = git_status.new()
local add_oil = function()
  local oil = require('oil')
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  if entry.type == 'directory' then
    require('oil.actions').select.callback()
    return
  end

  local path = oil.get_current_dir() .. entry.name
  local curr_win = vim.api.nvim_get_current_win()

  vim.cmd('wincmd p')
  vim.cmd('edit ' .. vim.fn.fnameescape(path))
  vim.api.nvim_set_current_win(curr_win)
end

---@type LazyPluginSpec
M.spec = {
  'stevearc/oil.nvim',
  lazy = false,
  keys = { { '-', '<Cmd>Oil<CR>' } },
  opts = function()
    local refresh = require('oil.actions').refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status_cache = git_status.new()
      orig_refresh(...)
    end

    ---@type oil.setupOpts
    return {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      constrain_cursor = 'name',
      watch_for_changes = true,
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
          if name == '../' then
            return false
          end
        end,
      },

      keymaps = {
        ['h'] = { 'actions.parent', mode = 'n' },
        ['l'] = {
          desc = 'Send to other window',
          callback = function()
            add_oil()
          end,
        },
        ['<Left>'] = { 'actions.parent', mode = 'n' },
        ['<Right>'] = {
          desc = 'Send to other window',
          callback = function()
            add_oil()
          end,
        },
        ['q'] = { 'actions.close', mode = 'n' },
        ['<Tab>'] = { 'actions.close', mode = 'n' },
        ['gi'] = {
          desc = 'Toggle file detail view',
          callback = function()
            detail = (detail + 1) % 3
            local oil = require('oil')
            if detail == 0 then
              oil.set_columns({ 'icon' })
            elseif detail == 1 then
              oil.set_columns({ 'icon', 'permissions', 'size', 'mtime' })
            else
              oil.set_columns({})
            end
          end,
        },
        ['yf'] = { 'actions.yank_entry', mode = 'n' },
        ['z'] = { '<Cmd>Zoxide<CR>' },
      },
    }
  end,
}

return M.spec
