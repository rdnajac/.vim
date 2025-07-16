" Maps <C-h/j/k/l> to switch vim splits in the given direction.
" If there are no more windows in that direction, forwards the operation to tmux.
let g:tmux_navigator_save_on_switch = 0
let g:tmux_navigator_disable_when_zoomed = 0
let g:tmux_navigator_preserve_zoom = 0
let g:tmux_navigator_no_wrap = 0

function s:err(msg)
  echohl ErrorMsg | echo msg | echohl None
endfunction

let s:direction_map = {'h': 'Left', 'j': 'Down', 'k': 'Up', 'l': 'Right', '\': 'previous'}
let s:pane_position_from_direction = {'h': 'left', 'j': 'bottom', 'k': 'top', 'l': 'right'}

" Normal mode mappings for <C-h/j/k/l> to switch vim splits.
for [key, direction] in items(s:direction_map)
  execute 'nnoremap <silent> <C-' . key . '> <Cmd>TmuxNavigate' . direction . '<CR>'
endfor

" The socket path is the first value in the comma-separated list of `$TMUX`
function! s:TmuxSocket()
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = 'tmux -S ' . s:TmuxSocket() . ' ' . a:args
  let l:x=&shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag=l:x
  return retval
endfunction

function! s:TmuxVimPaneIsZoomed()
  return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxNavigatorProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
  au!
  autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  return a:tmux_last_pane || a:at_tab_page_edge
endfunction

function! s:TmuxAwareNavigate(direction)
  if a:direction ==# 'previous'
    let a:direction = 'p'
  endif
  if empty($TMUX)
    execute 'wincmd ' . a:direction
  endif
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    execute 'wincmd ' . a:direction
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
      try
	update " save the active buffer. See :help update
      catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
      endtry
    elseif g:tmux_navigator_save_on_switch == 2
      try
	wall " save all the buffers. See :help wall
      catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
      endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
      let l:args .= ' -Z'
    endif
    if g:tmux_navigator_no_wrap == 1
      let args = 'if -F "#{pane_at_' . s:pane_position_from_direction[a:direction] . '}" "" "' . args . '"'
    endif
    silent call s:TmuxCommand(args)
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')

if !has('nvim')
  " `fzf` integration
  function! s:IsFZF()
    return &ft == 'fzf'
  endfunction
  for [key, direction] in items(s:direction_map)
    execute 'tnoremap <expr> <silent> <C-' . key . '> <SID>IsFZF() ? "\<C-' . key . '>" : "\<C-w>:\<C-U> TmuxNavigate' . direction . '\<CR>"'
  endfor

  " `netrw` workaround
  if !exists('g:Netrw_UserMaps')
    let g:Netrw_UserMaps = [['<C-l>', '<C-U>TmuxNavigateRight<CR>']]
  endif
endif
