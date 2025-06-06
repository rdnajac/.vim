function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  -- return LazyVim.lualine.pretty_path({
  --   relative = 'root',
  --   readonly_icon = '',
  --   number = 4,
  -- })
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local M = {}

M.new_git_status = function()
  local parse_output = function(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
        line = line:gsub('/$', '') -- Remove trailing slash
        ret[line] = true
      end
    end
    return ret
  end

  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' },
        { cwd = key, text = true }
      )
      local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, { cwd = key, text = true })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }
      rawset(self, key, ret)
      return ret
    end,
  })
end

local git_status = M.new_git_status()
local detail = 0

return {
  'stevearc/oil.nvim',
  lazy = false,
  -- stylua: ignore
  keys = {
    {
      '-',
      function()
        if vim.fn.winnr('$') == 1 then
          vim.cmd('Oil --float')
        else
          vim.cmd('Oil')
        end
      end,
      desc = 'Open Oil',
    } },
  opts = function()
    local refresh = require('oil.actions').refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status = M.new_git_status()
      orig_refresh(...)
    end

    ---@type oil.setupOpts
    return {
      default_file_explorer = true,
      -- win_options = {},
      -- delete_to_trash = true,
      -- prompt_save_on_select_new_entry = false,
      skip_confirm_for_simple_edits = true,
      constrain_cursor = 'name',
      watch_for_changes = true,
      view_options = {
        winbar = '%{%v:lua.get_oil_winbar()%}',
        -- winbar = '%!v:lua.get_oil_winbar()',

        is_hidden_file = function(name, bufnr)
          local dir = require('oil').get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, '.')

          if not dir then
            return is_dotfile
          end
          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            -- return git_status[dir].ignored[name]
            return false
          end
        end,

        is_always_hidden = function(name, _)
          if name == '../' then
            return false
          end
        end,
      },

      keymaps = {
        ['h'] = { 'actions.parent', mode = 'n' },
        -- ['l'] = { 'actions.select', mode = 'n' },
        ['l'] = {
          desc = 'Send to main window',
          callback = function()
            local oil = require('oil')
            local entry = oil.get_cursor_entry()
            if not entry or entry.type ~= 'file' then
              return
            end
            local path = oil.get_current_dir() .. entry.name
            vim.fn.chansend(vim.v.servername, string.format([[<Cmd>edit %s<CR>]], vim.fn.fnameescape(path)))
          end,
        },
        ['<Left>'] = { 'actions.parent', mode = 'n' },
        ['<Right>'] = { 'actions.select', mode = 'n' },
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
      },
    }
  end,
}
