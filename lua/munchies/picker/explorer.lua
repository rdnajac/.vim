return {
  cwd = vim.fn.getcwd(),
  ignored = true,
  win = {
    list = {
      keys = {
        -- ['<Up>'] = 'explorer_up',
        -- ['<Down>'] = 'explorer_down',
        ['<Left>'] = 'explorer_up',
        ['<Right>'] = 'confirm',
        ['<BS>'] = 'explorer_up',
        ['l'] = 'confirm',
        ['h'] = 'explorer_close', -- close directory
        ['a'] = 'explorer_add',
        ['d'] = 'explorer_del',
        ['c'] = 'explorer_copy',
        ['m'] = 'explorer_move',
        ['o'] = 'explorer_open', -- open with system application
        ['p'] = 'explorer_paste',
        ['r'] = 'explorer_rename',
        ['u'] = 'explorer_update',
        ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
        -- ['z'] = {
        --   function(self)
        --     require('munchies.picker.zoxide').cd_and_resume_picking(self)
        --   end,
        -- },
        ['P'] = 'toggle_preview',
        ['<c-c>'] = 'tcd',
        ['<leader>/'] = 'picker_grep',
        ['<c-t>'] = 'terminal',
        ['.'] = 'explorer_focus',
        ['I'] = 'toggle_ignored',
        ['H'] = 'toggle_hidden',
        ['Z'] = 'explorer_close_all',
        [']g'] = 'explorer_git_next',
        ['[g'] = 'explorer_git_prev',
        [']d'] = 'explorer_diagnostic_next',
        ['[d'] = 'explorer_diagnostic_prev',
        [']w'] = 'explorer_warn_next',
        ['[w'] = 'explorer_warn_prev',
        [']e'] = 'explorer_error_next',
        ['[e'] = 'explorer_error_prev',
      },
    },
  },
}
