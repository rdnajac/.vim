MAXSIZE = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add({
  pattern = {
    ['.*'] = {
      -- If any file is larger than a certain size, its filetype becomes `bigfile`,
      -- disabling syntax highlighting and features that cause performance issues,
      function(path, bufnr)
        if
          path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
          or vim.bo[bufnr].filetype == 'bigfile'
        then
          return
        end
        local size = vim.fn.getfsize(path)
        if size > MAXSIZE then
          Snacks.notify.warn(('This is a beeeg file (%s)!'):format(Snacks.debug.size(size)))
          return 'bigfile'
        end
      end,
    },
  },
})
