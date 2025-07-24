setlocal expandtab
setlocal formatoptions-=ro

let &l:formatprg = 'sh -c "cd ' . shellescape(expand('%:p:h')) . ' && stylua --search-parent-directories -"'

" simple auto-brackets
" inoremap <buffer> ( ()<Left>
" inoremap <buffer> ' ''<Left>
inoremap <buffer> {<SPACE> {}<LEFT><LEFT><SPACE><LEFT><SPACE>
" inoremap <buffer> {<CR> {<CR>}<C-c>O
" inoremap <buffer> {, {<CR>},<C-c>O

inoremap <buffer> [[<CR> ([[<CR><CR>]])<UP>

inoremap <buffer> \si  --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \sis --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \sie --<SPACE>stylua:<SPACE>ignore<SPACE>end

inoremap <buffer> \fu function() end,<Esc>gEa<Space>
inoremap <buffer> \vc vim.cmd([[<c-g>u]])<Left><Left><Left><CR><CR><esc>hi<Space><Space>

" WIP.. TODO: map to `cr` like with CoeRce from `vim-abolish`
" local function transform

" `CoeRce` - change `local` to `M` and back (normal mode)
" keymaps work from anywhere on the line as long as the
" entire line is formatted consistently

" some important notes:
" 0 - start at the beginning of the line
" <C-O> - from insert mode, execute the next normal mode command

" `local function fn(...)` --> `M.fn = function(...)`
nnoremap <buffer> crM <Cmd>normal! 0dwdiM.<C-O>w = <Esc>p<CR>
nnoremap <buffer> crM 0dwdiM.<C-o>w = <Esc>p

" and in the other direction...
nnoremap <buffer> crm 0dwdiwM.<C-o>w \<Space>=\<Space><Esc>p

" local to M
" noremap <buffer> crM viwb<esc>cf<space>M.<esc>

" `local function fn()`-> M.fn = function()
" start with the cursor on `local`

" nmap <leader>cm ^v2f<Space>cM.<Es\ac>

" nmap <leader>cl ^wdwf(i<Space>=<Space><Esc>px
" local to M transform
" M transform
" nmap <leader>cM ^v2f<Space>cM.<Esc>
finish

