nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

" TODO: make line continuations in vim act like a bulleted list
let s:dirs = {
      \ '~': $HOME,
      \ 'G': $HOME.'/GitHub/',
      \ 'V': $VIMRUNTIME,
      \ 'v': g:vimrc#dir,
      \ 'p': g:plug#home,
      \ 'B': &backupdir,
      \ 'c': g:stdpath['config'],
      \ 'C': g:stdpath['cache'],
      \ 'd': g:stdpath['data'],
      \ 's': g:stdpath['state'],
      \ '.': '~/.local/share/chezmoi/',
      \ }
" g:chezmoi#source_dir_path

for [key, value] in items(s:dirs)
  execute printf('nnoremap cd%s <Cmd>edit %s<CR>', key, fnamemodify(value, ":~"))
  " PERF : if explorer is already open this should behave differently
endfor

if !has('nvim')
  finish
endif
set nocdhome " default on neovim on unix, off on Windows or vim

" handle OSC 7 dir change requests
augroup cd_osc7
  autocmd!
  " autocmd TermRequest * call term#print_request()
  autocmd TermRequest * call term#handleOSC7()

  " autocmd DirChanged * call chansend(v:stderr, printf("\033]7;file://%s\033\\", getcwd()))
  " Shells can emit the `OSC 7` sequence to announce when the current directory (CWD) changed.
  " If your terminal doesn't already do this for you, you can configure your shell to emit it.
  "
  " To configure bash to emit OSC 7:
  " print_osc7() { printf '\033]7;file://%s\033\\' "$PWD"; }
  " PROMPT_COMMAND='print_osc7'

  " ~/.local/share/chezmoi/dot_config/zsh/dot_zshrc:65
  " printf "\033]7;file://./foo/bar\033\\"
augroup END
