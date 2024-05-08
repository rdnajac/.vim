" lines thatbegin with # are all red
" add a new syntax highlighting rule for comments
" add a new highlight called VeryBad
"highlight VeryBad ctermfg=red guifg=red ctermbg=black guibg=black
"syntax match VeryBad "^#.*" contains=ALL
"TODO tell vim that # does not start comments in vimscript
syntax match VeryBad "^#.*" contains=ALL
highlight VeryBad ctermfg=red guifg=red ctermbg=black guibg=black

