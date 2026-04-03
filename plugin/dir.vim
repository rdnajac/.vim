nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

let s:dirs = {
      \ '~': $HOME,
      \ 'G': $HOME.'/GitHub/',
      \ 'V': $VIMRUNTIME,
      \ 'v': g:vimrc#dir,
      \ 'p': g:plug#home,
      \ 'B': &backupdir,
      \ '.': '~/.local/share/chezmoi/',
      \ }

" TODO: reuse code from `autoload/vim/stdpath.vim`
if exists('*stdpath')
  let s:dirs.C = stdpath('cache')
  let s:dirs.c = stdpath('config')
  let s:dirs.d = stdpath('data')
  let s:dirs.s = stdpath('state')
else
  let s:dirs.C = empty($XDG_CACHE_HOME)  ? expand('~/.cache') : expand('$XDG_CONFIG_HOME') .. '/vim'
  let s:dirs.c = empty($XDG_CONFIG_HOME) ? expand('~/.config') : expand('$XDG_CONFIG_HOME')  .. '/vim'
  let s:dirs.d = empty($XDG_DATA_HOME)   ? expand("~/.local/share") : expand('$XDG_DATA_HOME')  .. '/vim'
  let s:dirs.s = empty($XDG_STATE_HOME)  ? expand('~/.local/state') : expand('$XDG_STATE_HOME')  .. '/vim'
endif

for [key, value] in items(s:dirs)
  execute $'nnoremap cd{key} <Cmd>edit {value}<CR>'
endfor

if has('nvim')
  set nocdhome " default on neovim on unix, off on Windows or vim
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
endif
