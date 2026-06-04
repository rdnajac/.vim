-- Step 8 of vim initialization: Enable filetype detection:
-- `:runtime! filetype.lua`

MAXSIZE = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add({
  extension = {
    ['log'] = 'log', -- not enabled by default
  },
  pattern = {
    ['.*/tmux/.*%.conf'] = 'tmux', -- files ending with `.conf` in a tmux directory
    ['.*'] = {
      --- If any file is larger than a certain size, its filetype becomes `bigfile`,
      --- disabling syntax highlighting and features that cause performance issues,
      ---
      ---@param path string
      ---@param bufnr integer
      ---@return string?
      function(path, bufnr)
        if
          path == vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and vim.fn.getfsize(path) > MAXSIZE
        then
          return 'bigfile'
        end
      end,
    },
  },
})
