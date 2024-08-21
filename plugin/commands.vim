" plugin/commands.vim
" note: exclude [!] to prevent clobbering existing commands

command -nargs=0 LOL   execute utils#lol()
command -nargs=0 Make  execute 'silent make! %' | redraw! 
command -nargs=0 Ctags execute 'ctags --recurse --tag-relative -f ./.git/tags .'

