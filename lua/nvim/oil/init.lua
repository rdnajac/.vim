local M = { 'stevearc/oil.nvim' }

local detail = 0
local new_git_status = require('nvim.oil.git_status')
local git_status = new_git_status()

---@type oil.setupOpts
M.opts = {
  default_file_explorer = vim.g.file_explorer == 'oil',
  -- skip_confirm_for_simple_edits = true,
  constrain_cursor = 'name',
  win_options = {
    conceallevel = 2,
  },
  watch_for_changes = true,
  keymaps = {
    ['Y'] = { 'actions.yank_entry', opts = { modify = ':~' } },
    ['q'] = { 'actions.close', mode = 'n' },
    ['<Tab>'] = { 'actions.close', mode = 'n' },
    ['<Left>'] = { 'actions.parent', mode = 'n' },
    ['<Right>'] = { 'actions.select', mode = 'n' },
    ['h'] = { 'actions.parent', mode = 'n' },
    ['l'] = { 'actions.select', mode = 'n' },
    ['O'] = {
      function()
        local path = require('oil').get_cursor_entry().parsed_name
        if path then
          vim.fn.system({ 'open', path })
        end
      end,
    },
    ['z'] = '<Cmd>Zoxide<CR>',
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
        -- Show dotfiles if tracked
        return not status.tracked[name]
      else
        -- Hide files if gitignored
        return status.ignored[name] or false
      end
    end,

    is_always_hidden = function(name, _)
      return name == '../'
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

M.after = function()
  -- Clear git status cache on refresh
  local refresh = require('oil.actions').refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
  end
  vim.keymap.set('n', '-', '<Cmd>Oil<CR>')
  require('nvim.oil.autocmds')
end

return M
