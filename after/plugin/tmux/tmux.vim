" Maps <C-h/j/k/l> to switch vim splits in the given direction.
" If there are no more windows in that direction, forwards the operation to tmux.
let g:tmux_navigator_disable_when_zoomed = 0
let g:tmux_navigator_preserve_zoom = 0
let g:tmux_navigator_no_wrap = 0

function s:err(msg)
  echohl ErrorMsg | echo msg | echohl None
endfunction

let s:pane_position_from_direction = {'h': 'Left', 'j': 'Bottom', 'k': 'Top', 'l': 'Right'}

for [key, direction] in items(s:pane_position_from_direction)
  execute 'command! TmuxNavigate' . direction . ' call s:TmuxAwareNavigate("' . key . '")'
  " Normal mode mappings for <C-h/j/k/l> to switch vim splits
  execute 'nnoremap <silent> <C-' . key . '> <Cmd>TmuxNavigate' . direction . '<CR>'

  " Terminal mode mappings with special handling of `fzf`
  execute 'tnoremap <expr><silent> <C-' . key . '> (&ft ==# "fzf") ? "\<C-' . key . '>" : "\<C-\\>\<C-n>:TmuxNavigate' . direction . '<CR>"'
endfor

function! s:TmuxSocket()
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = 'tmux -S ' . s:TmuxSocket() . ' ' . a:args
  let l:save_shellcmdflag = &shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag = l:save_shellcmdflag
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
  return !(g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()) &&
	\ (a:tmux_last_pane || a:at_tab_page_edge)
endfunction

function! s:TmuxAwareNavigate(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane || !exists('$TMUX')
    execute 'wincmd ' . a:direction
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
      let l:args .= ' -Z'
    endif
    if g:tmux_navigator_no_wrap == 1
      let args = 'if -F "#{pane_at_' . tolower(s:pane_position_from_direction[a:direction]) . '}" "" "' . args . '"'
    endif
    silent call s:TmuxCommand(args)
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

" `netrw` workaround
if !has('nvim') && !exists('g:Netrw_UserMaps')
  let g:Netrw_UserMaps = [['<C-l>', '<C-U>TmuxNavigateRight<CR>']]
endif
