-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

vim.filetype.add({
  extension = {
    ['log'] = 'log',
    ['nv'] = 'lua',
  },
  pattern = {
    ['.*%.env%..*'] = 'sh',
    ['.*/tmux/.*%.conf'] = 'tmux',
  },
})
