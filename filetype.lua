-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

MAXSIZE = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add({
  extension = {
    ['log'] = 'log', -- not enabled by default
  },
  pattern = {
    ['.*/tmux/.*%.conf'] = 'tmux',
    ['.*'] = {
      function(path, bufnr)
        return path == vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and vim.fn.getfsize(path) > MAXSIZE
          and 'bigfile'
      end,
    },
  },
})
