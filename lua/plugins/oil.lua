local M = { 'stevearc/oil.nvim' }

local git_status = require('util.git_status')
local git_status_cache = git_status.new()
local detail = 0

---@type oil.setupOpts
M.opts = {
  default_file_explorer = true,
  -- skip_confirm_for_simple_edits = true,
  constrain_cursor = 'name',
  watch_for_changes = true,
  keymaps = {
    ['q'] = { 'actions.close', mode = 'n' },
    ['<Tab>'] = { 'actions.close', mode = 'n' },
    ['<Left>'] = { 'actions.parent', mode = 'n' },
    ['<Right>'] = { 'actions.select', mode = 'n' },
    ['h'] = { 'actions.parent', mode = 'n' },
    ['l'] = { 'actions.select', mode = 'n' },
    ['Y'] = { 'actions.yank_entry', mode = 'n' },
    ['z'] = {
      callback = function()
        Snacks.picker.zoxide({
          confirm = 'edit',
        })
      end,
    },
    ['gi'] = {
      desc = 'Toggle file detail view',
      callback = function()
        local columns = {}
        detail = (detail + 1) % 3

        if detail == 0 then
          columns = { 'icon' }
        elseif detail == 1 then
          columns = { 'icon', 'permissions', 'size', 'mtime' }
        end
        require('oil').set_columns(columns)
      end,
    },
    -- [':'] = {
    --   'actions.open_cmdline',
    --   opts = {
    --     shorten_path = false,
    --     modify = '~:',
    --   },
    --   desc = 'Open the command line with the current directory as an argument',
    --   mode = 'n',
    -- },
  },
  win_options = { signcolumn = 'yes:2' },
  float = { get_win_title = nil },
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

  -- stylua: ignore
M.keymaps = function()
  vim.keymap.set('n', '-', function() require('oil').open_float() end, { desc = 'Open Oil in float' })
  vim.keymap.set('n', '_', function() require('oil').open() end, { desc = 'Open Oil in current window' })
end

M.git = function()
  local refresh = require('oil.actions').refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status_cache = git_status.new()
    orig_refresh(...)
  end
end

M.config = function()
  require('oil').setup(M.opts)
  M.git()
  M.keymaps()
end

return M
