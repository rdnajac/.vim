" Ensure that # does not start comments in vimscript
" TODO check https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
" for the right way to override any highlighting without editing the colorscheme
highlight VeryBad ctermfg=red guifg=red ctermbg=black guibg=black
syntax match VeryBad '^#.*'
