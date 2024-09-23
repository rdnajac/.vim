" vim/plugin/commands.vim

" Define commands like this
" exclude [!] to prevent clobbering existing commands
command -nargs=0 LOL   execute utils#lol()
command -nargs=0 Make  execute 'silent make! %' | redraw! 
command -nargs=0 Ctags execute 'ctags --recurse --tag-relative -f ./.git/tags .'
command -nargs=0 Fmt   call utils#format#FormatBuffer()

command -nargs=0 GetInfo call info#get()
command -nargs=* VX call run#file_with_args(<f-args>)
command -nargs=1 -complete=command -bar -range Redir silent call redirect#output(<q-args>, <range>, <line1>, <line2>)
command -nargs=0 Notify call popup#notify()
command -nargs=1 Popup call popup#show(<f-args>)
command -nargs=0 BinBash call file#add_bin_bash_shebang()
command -nargs=0 RunFile call run#file()
command -nargs=* RunFileWithArgs call run#file_with_args(<f-args>)
command -nargs=0 RunVisualSelectionAsShellCmd call run#visual_selection_as_shell_cmd()
command -nargs=0 RunVisualSelectionAsVimScript call run#visual_selection_as_vimscript()
command -nargs=1 EXE call run#in_tmux_pane(<f-args>)
