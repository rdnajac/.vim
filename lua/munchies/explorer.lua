return {
  git_untracked = false,
  win = {
    list = {
      keys = {
        ['-'] = 'explorer_up',
        -- ['l'] = 'confirm',
        -- ['h'] = 'explorer_close',
        ['<Right>'] = 'confirm',
        ['<Left>'] = 'explorer_close',
        ['c'] = 'explorer_copy',
        ['m'] = 'explorer_move',
        ['r'] = 'explorer_rename',
        -- ['o'] = 'explorer_open',
        ['P'] = 'toggle_preview',
        ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
        ['p'] = 'explorer_paste',
        ['u'] = 'explorer_update',
      },
    },
  },
}
