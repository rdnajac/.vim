setlocal expandtab
setlocal formatoptions -=ro

let &l:formatprg = 'sh -c "cd ' . shellescape(expand('%:p:h')) . ' && stylua --search-parent-directories -"'

" simple auto-brackets
" inoremap <buffer> ( ()<Left>
" inoremap <buffer> ' ''<Left>
inoremap <buffer> {<SPACE> {},<LEFT><LEFT><SPACE><LEFT><SPACE>
inoremap <buffer> {<CR> {<CR>},<C-c>O
inoremap <buffer> {, {<CR>},<C-c>O

inoremap <buffer> [[<CR> ([[<CR><CR>]])<UP>

inoremap <buffer> \uf ---@diagnostic disable-next-line: undefined-field
inoremap <buffer> \mf ---@diagnostic disable-next-line: missing-fields
inoremap <buffer> \ul ---@diagnostic disable-next-line: unused-local

inoremap <buffer> \si  --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \sis --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \sie --<SPACE>stylua:<SPACE>ignore<SPACE>end

inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \vc vim.cmd([[<c-g>u]])<Left><Left><Left><CR><CR><esc>hi<Space><Space>

" local function transform
nmap <leader>cl ^wdwf(i<Space>=<Space><Esc>px

" local to M transform
nmap <leader>cm ^v2f<Space>cM.<Es\ac>

" M transform
nmap <leader>cM ^v2f<Space>cM.<Esc>

if has ('nvim')
  call fold#text()
  lua Snacks.utils.highlight('LspReferenceText', { link = NONE })
endif

