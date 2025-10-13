local M = { 'stevearc/oil.nvim' }

local detail = 0
local new_git_status = require('nvim.util.git.status')
local git_status = new_git_status()

---@type oil.setupOpts
M.opts = {
  -- skip_confirm_for_simple_edits = true,
  constrain_cursor = 'name',
  win_options = { conceallevel = 2, number = false, signcolumn = 'yes:2' },
  watch_for_changes = true,
  keymaps = {
    -- ['h'] = { 'actions.parent', mode = 'n' },
    -- ['l'] = { 'actions.select', mode = 'n' },
    ['<Left>'] = { 'actions.parent', mode = 'n' },
    ['<Right>'] = { 'actions.select', mode = 'n' },
    ['<Tab>'] = { 'actions.close', mode = 'n' },
    ['O'] = {
      function()
        local path = require('oil').get_cursor_entry().parsed_name
        if path then
          local abs_path = vim.fn.fnamemodify(path, ':p')
          dd('Opening ' .. abs_path)
          vim.fn.system({ 'open', abs_path })
        end
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
    ['q'] = { 'actions.close', mode = 'n' },
    ['yp'] = { 'actions.yank_entry', opts = { modify = ':~' } },
    ['~'] = '<Cmd>Zoxide<CR>',
    [';'] = {
      'actions.open_cmdline',
      opts = { shorten_path = false, modify = ':~' },
      desc = 'Open cmdline with current directory as an argument',
    },
  },
  -- win_options = { signcolumn = 'yes:2' },
  float = {
    ---@type fun(winid: integer): string
    get_win_title = function(winid)
      return ' ' .. M.winbar(winid) .. ' '
    end,
  },
  view_options = {
    is_hidden_file = function(name, bufnr)
      local dir = require('oil').get_current_dir(bufnr)
      local is_dotfile = vim.startswith(name, '.') and name ~= '..'
      if not dir then
        return is_dotfile
      end
      local status = git_status[dir]
      if is_dotfile then
        return not status.tracked[name]
      else
        return status.ignored[name] or false
      end
    end,
    is_always_hidden = function(name, _)
      return name == '..'
    end,
  },
}

--- Get a path for winbar display
---@param winid? integer
---@return string
M.winbar = function(winid)
  local buf = vim.api.nvim_win_get_buf(winid or vim.g.statusline_winid)
  if not buf then
    return ''
  end

  local path = require('oil').get_current_dir(buf) or vim.api.nvim_buf_get_name(buf)
  return path ~= '' and vim.fn.fnamemodify(path, ':~') or ''
end

M.keys = {
  { '-', '<Cmd>Oil --float<CR>' },
  { '_', '<Cmd>Oil<CR>' },
}

M.after = function()
  local refresh = require('oil.actions').refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
  end

  local aug = vim.api.nvim_create_augroup('oil', {})

  vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    group = aug,
    callback = function(ev)
      if ev.data.actions.type == 'move' then
        Snacks.rename.on_rename_file(ev.data.actions.src_url, ev.data.actions.dest_url)
      end
    end,
    desc = 'Snacks rename on Oil move',
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPre',
    group = aug,
    callback = function(ev)
      for _, action in ipairs(ev.data.actions) do
        if action.type == 'delete' then
          local path = action.url:sub(#'oil://' + 1)
          Snacks.bufdelete({ file = path, force = true, wipe = true })
        end
      end
    end,
    desc = 'Delete buffer on Oil delete',
  })

  require('nvim.util.git.oil_exmarks').setup()
end

return M
