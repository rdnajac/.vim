-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

vim.filetype.add({
  pattern = {
    ['.*/kitty/.*%.conf'] = 'kitty',
    ['.*/kitty%.conf'] = 'kitty',
    ['.*%.env%..*'] = 'sh',
    ['.*/tmux/.*%.conf'] = 'tmux',
  },
})
