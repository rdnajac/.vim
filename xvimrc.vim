" experimental vim settings
set fillchars=fold:\ ,foldopen:▾,foldclose:▸,foldsep:│
set wildmenu
set wildmode=longest:full,full
set fo-=o
set conceallevel=0
set fillchars+=eob:\                " don't show end of buffer as a column of ~
set fillchars+=stl:\                " display spaces properly in statusline
set list listchars=trail:¿,tab:→\   " show trailing whitspace and tabs
set completeopt=menuone,noselect    " show menu even if there's only one match
set report=0                        " display how many replacements were made
set shortmess+=A                    " avoid "hit-enter" prompts


color yowish 
hi Normal guibg=#000000
hi String guifg=#39FF14
