let s:conceal = ' conceal'

" Define syntax regions for different Markdown elements
syntax region mkdFootnotes matchgroup=mkdDelimiter start="\[" end="\]" contained oneline
syntax region mkdID matchgroup=mkdDelimiter start="\[" end="\]" contained oneline
syntax region mkdURL matchgroup=mkdDelimiter start="(" end=")" contained oneline
syntax region mkdLink matchgroup=mkdDelimiter start="\[\[" end="]" contains=mkdID,mkdURL oneline

" Highlight groups
highlight mkdLink ctermfg=Blue guifg=Blue
highlight mkdURL ctermfg=DarkGray guifg=DarkGray
highlight mkdReference ctermfg=DarkGray guifg=DarkGray
highlight Conceal ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE

" Define syntax for link text
syntax region mkdLinkText matchgroup=mkdDelimiter start="\[" end="\]" contains=mkdReference oneline
syntax match mkdReference '\[[^]]*\]' contained

" Conceal links and references
syntax match mkdConcealLink '\[[^]]*\](\S\+)' conceal
syntax match mkdConcealRef '\[[^]]*\]\[[^]]*\]' conceal

