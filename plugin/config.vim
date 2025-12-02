scriptencoding utf-8
" command! -nargs=? -complete=dir Explore Dirvish <args>
" command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
" command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
let g:dirvish_mode = ':sort ,^.*[\/],'
" lua vim.g.dirvish_mode = [[:sort ,^.*[\/],]]
let g:eunuch_interpreters = {
      \ '.':      '/bin/sh',
      \ 'sh':     'bash',
      \ 'bash':   'bash',
      \ 'lua':    'nvim -l',
      \ 'python': 'python3',
      \ 'r':      'Rscript',
      \ 'rmd':    'Rscript',
      \ 'zsh':    'zsh',
      \ }

let g:vimtex_format_enabled = 1              " built-in formatexpr
let g:vimtex_mappings_disable = {'n': ['K']} " disable normal `K`
let g:vimtex_quickfix_method = executable('pplatex') ? 'pplatex' : 'latexlog'

if exists('g:chezmoi#source_dir_path')
  " let g:chezmoi#source_dir_path = expand('~/.local/share/chezmoi')
  let g:chezmoi#use_tmp_buffer = 1

  augroup chezmoi
    autocmd!
    " automatically `chezmoi add` aliases and binfiles
    au BufWritePost ~/.bash_aliases,~/bin/* silent! execute
	  \ '!chezmoi add "%" --no-tty >/dev/null 2>&1' | redraw!

    " immediately `chezmoi apply` changes when writing to a chezmoi file
    exe printf('au BufWritePost %s/* silent! !chezmoi apply --force --source-path "%%"',
	  \ g:chezmoi#source_dir_path)

  augroup END
endif

if !has ('nvim')
  finish
endif

" ale {{{
let g:ale_virtualtext_cursor = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_cursor = 'never'
" move fixers to ftplugin if we use `vim.lsp` for formatting
let g:ale_fixers = {
      \ '*'	  : ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python'  : ['ruff'],
      \ 'sh'	  : ['shfmt','shellharden'],
      \ 'r'	  : ['styler'],
      \ }

let g:ale_linters = {
      \ 'lua' : ['lua_language_server'],
      \ 'vim' : ['vint'],
      \ }

if has('nvim')
  let g:ale_completion_enabled = 0
  let g:ale_disable_lsp = 1
  let g:ale_use_neovim_diagnostics_api = 1
else
  hi clear ALEErrorSign
  hi clear ALEWarningSign
  let g:ale_sign_error   = '🔥'
  let g:ale_sign_warning = '💩'
  let g:ale_floating_window_border =
	\ ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
endif

nnoremap <leader>aD <Cmd>ALEGoToDefinition<CR>
nnoremap <leader>aF <Cmd>ALEFix<CR>
nnoremap <leader>aI <Cmd>ALEInfo<CR>
nnoremap <leader>al <Cmd>ALELint<CR>
nnoremap <leader>an <Cmd>ALENext<CR>
nnoremap <leader>ap <Cmd>ALEPrevious<CR>
nnoremap <leader>aq <Cmd>ALEDetail<CR>
nnoremap <leader>ar <Cmd>ALEFindReferences<CR>


augroup myalesettings
  au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
augroup END

" }}}

" vim: fdm=marker fdl=0
