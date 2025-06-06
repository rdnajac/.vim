runtime! after/ftplugin/vim.vim

setlocal expandtab
setlocal formatprg=stylua\ --search-parent-directories\ -

setlocal formatoptions-=o
setlocal autochdir

if !exists('g:AutoPairsLoaded')
  inoremap <buffer> {<SPACE> {}<LEFT><SPACE><LEFT><SPACE>
  inoremap <buffer> {<CR> {<CR>}<ESC>O
  " imap vim.cmd vim.cmd([[<c-g>u]])<Left><Left><Left><CR><CR><esc>hi<Space><Space>
endif

" nnoremap <buffer> \mf i---@diagnostic disable-next-line: missing-fields<esc>
" nnoremap <buffer> \ul i---@diagnostic disable-next-line: unused-local<esc>
" nnoremap <buffer> \uf i---@diagnostic disable-next-line: undefined-field<esc>

inoremap <buffer> \si  --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \ss --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \se --<SPACE>stylua:<SPACE>ignore<SPACE>end

" snippets
" lua vim.snippet.add('fn', 'function ${1:name}($2)\n\t${3:-- content}\nend')
" lua vim.snippet.add('lfn', 'local function ${1:name}($2)\n\t${3:-- content}\nend')

" do not highlight vimscript wrapped in `vim.cmd(...)`
if has ('nvim')
  lua vim.api.nvim_set_hl(0, 'LspReferenceText', {})
endif
