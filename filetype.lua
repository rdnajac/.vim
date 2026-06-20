-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

vim.filetype.add({
  extension = {
    -- not enabled by default
    ['log'] = 'log',
  },
  pattern = {
    -- files ending with `.conf` in a tmux directory
    ['.*/tmux/.*%.conf'] = 'tmux',
  },
})
