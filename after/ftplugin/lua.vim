setlocal expandtab
setlocal formatprg=stylua\ --search-parent-directories\ -

setlocal formatoptions-=o

if !exists('g:AutoPairsLoaded')
  inoremap <buffer> {<SPACE> {}<LEFT><SPACE><LEFT><SPACE>
  inoremap <buffer> {<CR> {<CR>}<ESC>O
  " imap vim.cmd vim.cmd([[<c-g>u]])<Left><Left><Left><CR><CR><esc>hi<Space><Space>
endif

" nnoremap <buffer> \mf i---@diagnostic disable-next-line: missing-fields<esc>
" nnoremap <buffer> \ul i---@diagnostic disable-next-line: unused-local<esc>
" nnoremap <buffer> \uf i---@diagnostic disable-next-line: undefined-field<esc>

inoremap <buffer> \si  --<SPACE>stylua:<SPACE>ignore
inoremap <buffer> \sis --<SPACE>stylua:<SPACE>ignore<SPACE>start
inoremap <buffer> \sie --<SPACE>stylua:<SPACE>ignore<SPACE>end

if has ('nvim')
  lua vim.api.nvim_set_hl(0, 'LspReferenceText', {})
endif
