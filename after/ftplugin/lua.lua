-- local id = nv.lsp.myserver.client_id
-- vim.lsp.buf_attach_client(0, id)

vim.wo.foldmethod = 'expr'
vim.wo.foldtext = [[v:lua.nv.foldtext()]]

if vim.g.loaded_endwise == 1 then
  vim.bo.syntax = 'ON' -- use legacy syntax
end

vim.b.minisurround_config = {
  custom_surroundings = {
    U = { output = { left = 'function()\n', right = '\nend' } },
    u = { output = { left = 'function() ', right = ' end' } },
    i = { output = { left = '-- stylua: ignore start\n', right = '\n-- stylua: ignore end' } },
    S = { output = { left = 'vim.schedule(function()\n  ', right = '\nend)' } },
    s = { input = { '%[%[().-()%]%]' }, output = { left = '[[', right = ']]' } },
  },
}

if MiniSplitjoin then
  local gen_hook = MiniSplitjoin.gen_hook
  local curly = { brackets = { '%b{}' } }
  local add_comma_curly = gen_hook.add_trailing_separator(curly)
  local del_comma_curly = gen_hook.del_trailing_separator(curly)
  local pad_curly = gen_hook.pad_brackets(curly)

  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  }
end

local aug = vim.api.nvim_create_augroup('lua', {})

if Snacks then
  -- TODO: only disable highlighting inside of `vim.cmd([[...]])`
  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = aug,
    callback = function()
      vim.b.old_hl = Snacks.util.color('LspReferenceText', 'bg')
      Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
    end,
  })
  vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    group = aug,
    callback = function()
      if vim.b.old_hl then
        Snacks.util.set_hl({ LspReferenceText = { bg = vim.b.old_hl } })
        vim.b.old_hl = nil
      end
    end,
  })
end
