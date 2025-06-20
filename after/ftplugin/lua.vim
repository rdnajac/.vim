setlocal expandtab
" setlocal formatprg=stylua\ --search-parent-directories\ -
let &l:formatprg = 'sh -c "cd ' . fnameescape(expand('%:p:h')) . ' && stylua --search-parent-directories -"'

" simple auto-braackets
" inoremap <buffer> ( ()<Left>
" inoremap <buffer> ' ''<Left>
inoremap <buffer> {<SPACE> {},<LEFT><LEFT><SPACE><LEFT><SPACE>
inoremap <buffer> {<CR> {<CR>},<ESC>O

inoremap <buffer> \mf ---@diagnostic disable-next-line: missing-fields
inoremap <buffer> \ul ---@diagnostic disable-next-line: unused-local
inoremap <buffer> \uf ---@diagnostic disable-next-line: undefined-field

inoremap <buffer> \si  --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \sis --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \sie --<SPACE>stylua:<SPACE>ignore<SPACE>end

inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \vc vim.cmd([[<c-g>u]])<Left><Left><Left><CR><CR><esc>hi<Space><Space>

" local function transform
nmap <leader>cl ^wdwf(i<Space>=<Space><Esc>px

" local to M transform
nmap <leader>cm ^v2f<Space>cM.<Esc>

" M transform
nmap <leader>cM ^v2f<Space>cM.<Esc>

if has ('nvim')
  lua vim.api.nvim_set_hl(0, 'LspReferenceText', {})
  setlocal foldmethod=expr
  setlocal foldexpr=v:lua.require('nvim.treesitter.fold').expr()
  setlocal foldlevel=0
  " lua vim.treesitter.start()
endif
setlocal foldtext=fold#text()
