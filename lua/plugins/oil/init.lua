local M = { 'stevearc/oil.nvim' }

-- M.dependencies = { 'refractalize/oil-git-status.nvim' }

local git_status = require('plugins.oil.git_status')
local git_status_cache = git_status.new()

local refresh = require('oil.actions').refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
  git_status_cache = git_status.new()
  orig_refresh(...)
end

---@type oil.setupOpts
M.opts = {
  default_file_explorer = true,
  -- skip_confirm_for_simple_edits = true,
  constrain_cursor = 'name',
  watch_for_changes = true,
  keymaps = require('plugins.oil.keymaps'),

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

M.autocmds = function()
  local myoilautocmds = vim.api.nvim_create_augroup('myoilautocmds', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    group = myoilautocmds,
    pattern = 'OilActionsPost',
    callback = function(ev)
      if ev.data.actions.type == 'move' then
        Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
      end
    end,
    desc = 'Snacks rename on Oil move',
  })

  vim.api.nvim_create_autocmd('User', {
    group = myoilautocmds,
    pattern = 'OilActionsPre',
    callback = function(ev)
      -- TODO: is this loop necessary?
      for _, action in ipairs(ev.data.actions) do
        if action.type == 'delete' then
          local _, path = require('oil.util').parse_url(action.url)
          Snacks.bufdelete({ file = path, force = true })
        end
      end
    end,
    desc = 'Delete buffer on Oil delete',
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = myoilautocmds,
    pattern = 'oil://*',
    callback = function()
      require('oil.actions').cd.callback({ silent = true })
    end,
    desc = 'Sync cd with Oil directory on buffer enter',
  })
end

M.config = function()
  M.autocmds()
  vim.keymap.set('n', '-', function()
    require('oil').open_float()
  end, { desc = 'Open Oil in float' })
  vim.keymap.set('n', '_', function()
    require('oil').open()
  end, { desc = 'Open Oil in current window' })
  require('oil').setup(M.opts)
end

return M
