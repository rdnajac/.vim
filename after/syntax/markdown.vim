" after/syntax/markdown.vim 

" Make code and H1 stand out more
hi! link markdownCode String
hi! link markdownH1   Constant 
hi! link Folded Cyan 

" alerts from gfm
syn region ghAlert start=/\[\!/ end=/\]/ contained
" syntax match mdAlert '\[\![NOTE|TIP|IMPORTANT|WARNING|CAUTION]\]'
syn match mdBlockQuote '^>.*' contains=ghAlert
hi! link mdBlockQuote Comment
hi! link ghAlert Todo

hi Cyan guifg=#14afff guibg=#000000

" " [link](URL) | [link][id] | [link][] | ![image](URL)
" "syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
" syn region mkdID  matchgroup=mkdDelimiter   start="\["    end="\]" contained oneline conceal
" syn region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline conceal
" "syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . concealends
" "                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
" " Autolink with parenthesis.
" syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"

hi! link markdownLinkText              Cyan
hi! link markdownUrl                   String
hi! link markdownAutomaticLink         markdownUrl
hi! link markdownUrlTitle              String

" these link to Statement...
" hi! link markdownOrderedListMarker
" hi! link markdownListMarker

" incorrectly matches "\w\@<=_\w\@=" as an error (eg $x_n$)
hi clear markdownError 
