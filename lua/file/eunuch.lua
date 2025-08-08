local aug = vim.api.nvim_create_augroup('shebang', { clear = true })

vim.api.nvim_create_autocmd('BufNewFile', {
  group = aug,
  callback = function()
    vim.b.chmod_shebang = 1
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = aug,
  callback = function()
    if not vim.fn.getline(1):match('^#!%s*%S') then
      vim.b.chmod_shebang = 1
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileWritePost' }, {
  group = aug,
  nested = true,
  callback = function(ev)
    if vim.b.chmod_shebang and vim.fn.getline(1):match('^#!%s*%S') then
      vim.fn.system({ 'chmod', '+x', ev.file })
      vim.cmd.edit()
    end
    vim.b.chmod_shebang = nil
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = aug,
  nested = true,
  callback = function()
    if vim.fn.line('.') == 1 and vim.fn.getline(1) == vim.fn.getreg('.') and vim.fn.getreg('.'):match('^#!%s*%S') then
      vim.cmd('filetype detect')
    end
  end,
})

-- augroup eunuch
--   autocmd!
--   autocmd BufWritePost,FileWritePost * nested
--         \ if exists('b:eunuch_chmod_shebang') && getline(1) =~# s:shebang_pat |
--         \   call s:Chmod(0, '+x', '<afile>') |
--         \   edit |
--         \ endif |
--         \ unlet! b:eunuch_chmod_shebang
--   autocmd InsertLeave * nested if line('.') == 1 && getline(1) ==# @. && @. =~# s:shebang_pat |
--         \ filetype detect | endif
--   autocmd VimEnter * call s:MapCR() |
--         \ if has('patch-8.1.1113') || has('nvim-0.4') |
--         \   exe 'autocmd eunuch InsertEnter * ++once call s:MapCR()' |
--         \ endif
-- augroup END
--
-- -- nvim autocmd bunewfile
-- n
