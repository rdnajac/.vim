local cmd = { 'vim', '-Nu', 'NONE', '-es', vim.api.nvim_buf_get_name(0), '-c', 'hardcopy | qa!' }
-- '--not-a-term',

local hardcopy = function() Snacks.terminal.open(cmd) end
-- works

vim.api.nvim_create_user_command('Hardcopy', hardcopy, {})

-- TODO: use `jobstart()` to remove snacks dep

-- vim.fn.jobstart(cmd, {term = true})
-- works

-- local cmdstr = ([[vim -Nu NONE --not-a-term -es %s -c 'hardcopy | qa!']]):format(
-- vim.fn.jobstart(vim -Nu NONE, {term = true})
-- ([[ %s]]):format(vim.api.nvim_buf_get_name(0)),
-- { term = true }
-- )
-- WIP

-- https://github.com/neovim/neovim/discussions/38256
vim.api.nvim_create_user_command('Clipboard', function()
  vim.api.nvim_buf_set_name(0, 'Clipboard')
  vim.cmd('put + | 1d')
  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = 0,
    callback = function(ev)
      vim.cmd('%y +')
      vim.bo[ev.buf].modified = false
    end,
  })
end, {
  desc = [[Usage: $ nvim +Clipboard # or alias pbedit='nvim +Clipboard']],
})
