" let &l:formatprg = 'stylua --search-parent-directories --stdin-filepath=% -'
let &l:formatprg = 'stylua -f ~/.vim/stylua.toml --stdin-filepath=% -'

setlocal comments=:---\ "
" setlocal nonumber signcolumn=yes:1
setlocal foldtext=v:lua.nv.foldtext()

iabbrev <buffer> fu function()
inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \ig --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> `` vim.cmd([[]])<Left><Left><Left><C-g>u<CR><CR><esc>hi<Space><Space>

inoremap <buffer> req<Tab> require(')<Left><Left>'

" NOTE: don't need `tpope/vim-apathy` for lua anymore:
" from `$VIMRUNTIME/runtime/ftplugin/lua.lua`
" includeexpr=v:lua.require'vim._ftplugin.lua'.includeexpr(v:fname)
" include=\<\%(\%(do\|load\)file\|require\)\s*(
" from ~/.local/share/nvim/share/nvim/runtime/ftplugin/lua.vim line 39

" custom surround using `tpope/vim-surround`
" use ascii value (i = 105)
" NOTE: must use double quotes
let b:surround_85 = "function() \r end"
let b:surround_117 = "function()\n \r \nend"
let b:surround_105 = "-- stylua: ignore start\n \r \n--stylua: ignore end"
let b:surround_115 = "vim.schedule(function()\n \r \nend)"

" coerce
" vim global to `vim.g.%s =`
nnoremap crv ^d3wivim.g.<Esc>
" vim.g to `let g:%s =`
nnoremap crV ^df4wilet<Space>g:<Esc>

if !has('nvim')
  finish
endif
setlocal foldmethod=expr

lua << EOF

vim.bo.syntax = 'ON' -- Keep using legacy syntax for `vim-endwise`
-- vim.wo.foldmethod = 'expr' -- foldexpression already set by ftplugin

local function nmap(lhs, rhs, desc)
vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

nmap('crf',   nv.coerce.form,      'local function foo() ↔ local foo = function()')
nmap('crM',   nv.coerce.formscope, 'local function foo() → M.foo = function()')
nmap('crF',   nv.coerce.scopeform, 'M.foo = function() → local function foo()')
-- FIXME: conflicts with abolish
-- nmap('crm',   nv.coerce.scope,     'local x ↔ M.x')

nmap('ym',    nv.yankmod.name,     'yank lua module name')
nmap('yM',    nv.yankmod.require,  'yank require(...) form')
nmap('yr',    nv.yankmod.func,     'yank require + function')
nmap('yR',    nv.yankmod.print,    'print require + function')
nmap('y<CR>', nv.yankmod.print,    'print require + function')

vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
      local link = require('mini.surround').user_input('Link: ')
      return { left = '[', right = '](' .. link .. ')' }
      end,
    },
    },
  }

local aug = vim.api.nvim_create_augroup('lua', {})

vim.api.nvim_create_autocmd({ 'InsertEnter', }, {
  group = aug,
  callback = function()
  vim.b.old_hl = Snacks.util.color('LspReferenceText', 'bg')
  Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave',  }, {
  group = aug,
  callback = function()
  if vim.b.old_hl then
    Snacks.util.set_hl({ LspReferenceText = { bg = vim.b.old_hl } })
    vim.b.old_hl = nil
    end
    end,
})

-- TODO: only disable highlighting inside of `vim.cmd([[...]])`
EOF
