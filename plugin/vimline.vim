scriptencoding=utf-8

if !has('nvim')
  finish
endif
" TODO: set defaults for these groups
" StatusLineNC
" TabLineFill
" Winbar
" Statusline{Term}{NC}

set showcmdloc=statusline
set statusline=%!MyStatusLine()
let &laststatus = has('nvim') ? 3 : 2
set noruler
" set tabline=%!MyTabline()
" set showtabline=2
" set winbar=%!MyWinbar()
if !has_key(environ(), 'TMUX')
  set statusline=%!MyTmuxLine()
else
  set statusline=%!MyStatusLine()
endif

function! MyWinBar() abort
  let l:winid = get(v:, 'statusline_winid', 0)
  let l:bufnr = winbufnr(l:winid)
  let l:file  = fnamemodify(bufname(l:bufnr), ':p')
  let l:root  = git#root(l:file)

  if !empty(l:file) && !empty(l:root)
    return path#relative(l:file, l:root)
  endif
  return ''
endfunction

" set winbar=%!MyWinBar()

function StatusRight() abort
  let l:line = ''
  let l:line .= ' %='               " Right alignment
  " let l:line .= vimline#components#lspprogress()
  let l:line .= '%#Black#'
  let l:line .= '%#Chromatophore_y#'
  let l:line .= vimline#luacomponent('searchcount') . ' '
  let l:line .= mode()
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= '%S '
  let l:line .= "%(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)"
  " let l:line .= vimline#recording()
  let l:line .= vimline#luacomponent('blink')
  let l:line .= '%#Black#'
  return line
endfunction


" TODO: write file component
function! MyTmuxLine() abort
  if bufname('%') =~# '^term://'
    " let l:prefix = getcwd()
    let l:prefix = '󱉭 ' . $PWD . ' '
    let l:suffix = 'channel: ' . &channel
  else
    let [l:root, l:suffix] = path#relative_parts()
    let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  endif
  let l:line = ''
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_ab#🭛'
  let l:line .= '%#Chromatophore_b#'
  let l:line .= l:suffix
  let l:line .= ' %#Chromatophore_bc#🭛'
  let l:line .= '%#Chromatophore_c#'
  let l:line .= vimline#flags() . ' '
  return l:line . StatusRight()
endfunction

function! Clock() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the tmux statusline
function! TmuxLeft() abort
  return vimline#tmuxline('MyTmuxLine')
endfunction

function! TmuxRight() abort
  return vimline#tmuxline('Clock')
endfunction

" Keep the recording component up to date
augroup vimline_macro
  autocmd!
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END

" Hide the statusline while in command mode
augroup vimline_cmdline
  autocmd!
  autocmd CmdlineEnter * let b:lastlaststatus = &laststatus | set laststatus=0
  autocmd CmdlineLeave * if exists('b:lastlaststatus') | let &laststatus = b:lastlaststatus | unlet b:lastlaststatus | endif
augroup END
