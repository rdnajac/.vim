vim.b.completion = false
vim.b.minihipatterns_disable = true
if vim.fn.exists(':NoMatchParen') == 2 then
  vim.cmd.NoMatchParen()
end
-- vim.cmd.setlocal('foldmethod=manual', 'statuscolumn=', 'conceallevel=0')
vim.cmd([[ setlocal foldmethod& statuscolumn& conceallevel& ]])

vim.schedule(function()
  vim.notify(('This is a beeeg file (%s)!'):format(nv.fs.filesize(), vim.log.levels.WARN))
  if vim.api.nvim_buf_is_valid(0) then
    local ft = vim.filetype.match({ buf = 0 }) or ''
    -- for json files, keep the filetype as json
    -- for other files, set the syntax to the detected ft
    local opt = ft == 'json' and 'filetype' or 'syntax'
    vim.bo[opt] = ft
  end
end)
