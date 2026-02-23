-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

vim.filetype.add({
  extension = {
    -- not enabled by default
    ['log'] = 'log',
    -- neovim scripting
    ['nv'] = 'lua',
    -- bioinformatics
    ['bed'] = 'csv',
  },
  pattern = {
    ['.*/tmux/.*%.conf'] = 'tmux',
    ['.*%.lua'] = {
      function(_, bufnr)
        local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        if first:match('^#!.*nvim.*') then
          return 'nv'
        end
      end,
    },
  },
})
