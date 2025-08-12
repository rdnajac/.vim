---@type snacks.picker.win.Config
local win = {
  preview = { minimal = true },
  input = {
    keys = {
      ['<Esc>'] = { 'close', mode = { 'n' } },
      -- change dir with zoxide and continue picking
      ['<m-z>'] = {
        function(picker, item)
          picker.close()
          picker.cd(item.file)
          Snacks.picker.zoxide({
            confirm = function(_, item)
              -- vim.cmd.cd(vim.fn.fnameescape(item.file))
              Snacks.picker.resume({ cwd = item.file })
            end,
          })
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
      -- <M-d> Delete forwards one word.
      ['<a-d>'] = { 'inspect', mode = { 'n' } },
      -- <M-f> Go forwards one word.
      ['<a-f>'] = { 'toggle_follow', mode = { 'n' } },
      -- <C-a> Go to beginning of line.
      ['<c-a>'] = { 'select_all', mode = { 'n' } },
      -- <C-b> Go backwards one character.  On a blank line, kill it
      ['<c-b>'] = { 'preview_scroll_up', mode = { 'n' } },
      -- <C-d> Delete character in front of cursor.  Falls back to
      ['<c-d>'] = { 'list_scroll_down', mode = { 'n' } },
    },
  },
}

return win
