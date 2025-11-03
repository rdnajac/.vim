  autocmd BufRead,BufNewFile * if getline(1) =~ '^#!.*\<nvim\>' | setfiletype nv | endif

