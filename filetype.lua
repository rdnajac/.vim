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
    -- ['.*%.lua'] = {
    --   function(_, bufnr)
    --     local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
    --     if first:match('^#!.*nvim.*') then
    --       return 'nv'
    --     end
    --   end,
    -- },
    ['.*'] = { -- bigfile detection
      function(path, bufnr)
        MAXSIZE = 1.5 * 1024 * 1024 -- 1.5MB
        if
          path == vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
          and vim.bo[bufnr].filetype ~= 'bigfile'
        then
          local size = vim.fn.getfsize(path)
          if size > 0 then
            if size > MAXSIZE then
              return 'bigfile'
            end
            local lines = vim.api.nvim_buf_line_count(bufnr)
            -- useful for minified files
            if (size - lines) / lines > 1024 then
              return 'bigfile'
            end
          end
        end
      end,
    },
  },
})
