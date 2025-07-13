local M = { 'folke/snacks.nvim' }
M.priority = 1000

---@module "snacks"
---@type snacks.Config
M.opts = {
  bigfile = { enabled = true },
  dashboard = require('plugins.snacks.dashboard').config,
  explorer = { replace_netrw = false },
  image = { enabled = true },
  indent = {
    enabled = true,
    indent = { only_current = true, only_scope = true },
  },
  input = { enabled = true },
  notifier = {
    enabled = false,
    style = 'fancy',
    date_format = '%T',
    timeout = 4000,
  },
  picker = { ---@type snacks.picker.Config {{{
    layout = { preset = 'ivy' },
    layouts = {
      ---@type snacks.picker.layout.Config
      mylayout = {
        reverse = true,
        layout = {
          box = 'vertical',
          backdrop = false,
          height = 0.4,
          row = vim.o.lines - math.floor(0.4 * vim.o.lines),
          {
            win = 'list',
            border = 'rounded',
            -- TODO: set titles in picker calls
            title = '{title} {live} {flags}',
            title_pos = 'left',
          },
          {
            win = 'input',
            height = 1,
          },
        },
        {
          win = 'input',
          height = 1,
        },
      },
    },
    sources = require('plugins.snacks.picker._default').sources,
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'n' } },
          ['<a-j>'] = { 'toggle', mode = { 'n', 'i' }, desc = 'Toggle Files/Grep' },
          ['<a-z>'] = {
            function(self)
              require('plugins.snacks.picker.zoxide').cd_and_resume_picking(self)
              -- Snacks.picker.actions.cd(_, item)
              -- Snacks.picker.actions.lcd(_, item)
            end,
            mode = { 'i', 'n' },
          },
          -- ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
          -- ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
          -- ['<C-c>'] = { 'cancel', mode = 'i' },
          -- ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
          -- ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
          -- ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
          -- ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
          -- ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
          -- ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
          -- ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
          -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
          -- ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
          -- ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
          -- ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
          -- ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          -- ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
          -- ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
          -- ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
          -- ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
          -- ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
          -- ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
          -- ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
          -- ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
          -- ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
          -- ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },

          -- remove insert mode keymaps that conflict with vim-rsi
          -- <M-d>                   Delete forwards one word.
          ['<a-d>'] = { 'inspect', mode = { 'n' } },
          -- <M-f>                   Go forwards one word.
          ['<a-f>'] = { 'toggle_follow', mode = { 'n' } },
          -- <C-a>                   Go to beginning of line.
          ['<c-a>'] = { 'select_all', mode = { 'n' } },
          -- <C-b>                   Go backwards one character.  On a blank line, kill it
          ['<c-b>'] = { 'preview_scroll_up', mode = { 'n' } },
          -- <C-d>                   Delete character in front of cursor.  Falls back to
          ['<c-d>'] = { 'list_scroll_down', mode = { 'n' } },
        },
      },
      preview = { minimal = true },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  -- TODO: set <CR> keymap to open a terminal in the current directory
  -- or to execute the scipt in the terminal
  -- scratch
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  styles = {
    lazygit = { height = 0, width = 0 },
    dashboard = { border = 'none' },
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = true,
    -- win = { wo = { winbar = '', winhighlight = 'Normal:SpecialWindow' } },
  },
  words = { enabled = true },
}

M.config = function()
  require('snacks').setup(M.opts)
  require('plugins.snacks.keymaps')
end

return M
