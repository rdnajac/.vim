command! -bar -bang -nargs=+ Chmod execute bin#chmod#chmod(<bang>0, <f-args>)
command! -bar -bang          Delete call bin#delete#delete(<bang>0)
command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)
