command -nargs=0 LOL execute function#lolcat()

command! -nargs=? -bar -range=% -bang -complete=customlist,neoformat#CompleteFormatters Fmt 
            \ call neoformat#Neoformat(<bang>0, <q-args>, <line1>, <line2>)
