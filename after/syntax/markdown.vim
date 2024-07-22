" after/syntax/markdown.vim 

syntax region ghAlert start=/\[\!/ end=/\]/ contained
" syntax match mdAlert '\[\![NOTE|TIP|IMPORTANT|WARNING|CAUTION]\]'
syntax match mdBlockQuote '^>.*' contains=ghAlert
hi! link mdBlockQuote Comment
hi! link ghAlert Todo

" let g:markdown_syntax_conceal = 1

" " [link](URL) | [link][id] | [link][] | ![image](URL)
" "syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"    end="\]"
" syn region mkdID matchgroup=mkdDelimiter    start="\["    end="\]" contained oneline conceal
" syn region mkdURL matchgroup=mkdDelimiter   start="("     end=")"  contained oneline conceal
" "syn region mkdLink matchgroup=mkdDelimiter  start="\\\@<!!\?\[\ze[^]\n]*\n\?[^]\n]*\][[(]" end="\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' . concealends
" "                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
" " Autolink with parenthesis.
" syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"


hi NeonGreen guifg=#39ff14 guibg=#000000
hi Cyan guifg=#14afff guibg=#000000
hi Magenta guifg=#da14ff guibg=#000000
hi Orange guifg=#ff6414 guibg=#000000

hi! link markdownCode NeonGreen

hi! link markdownH1 Constant 
hi! link Title Magenta
hi! link markdownH2 Title
hi! link markdownH3 Title
hi! link markdownH4 Title
hi! link markdownH5 Title
hi! link markdownH6 Title

hi! link markdownOrderedListMarker     NeonGreen
hi! link markdownListMarker            NeonGreen
hi! link markdownRule                  PreProc

hi! link markdownFootnote              Type
hi! link markdownFootnoteDefinition    Type
hi! link markdownIdDeclaration         Type
hi! link markdownId                    Type

hi! link markdownLinkText              Cyan
hi! link markdownUrl                   NeonGreen
hi! link markdownAutomaticLink         markdownUrl
hi! link markdownUrlTitle              String

hi! link Delimiter                     NeonGreen
hi! link markdownHeadingDelimiter      Delimiter
hi! link markdownIdDelimiter           Delimiter
hi! link markdownUrlDelimiter          Delimiter
hi! link markdownUrlTitleDelimiter     Delimiter
hi! link markdownLinkDelimiter         Delimiter
hi! link markdownLinkTextDelimiter     Delimiter

" hi! link markdownItalic                htmlItalic
" hi! link markdownItalicDelimiter       markdownItalic
" hi! link markdownBold                  htmlBold
" hi! link markdownBoldDelimiter         markdownBold
" hi! link markdownBoldItalic            htmlBoldItalic
" hi! link markdownBoldItalicDelimiter   markdownBoldItalic
" hi! link markdownStrike                htmlStrike
" hi! link markdownStrikeDelimiter       markdownStrike
" hi! link markdownCodeDelimiter         Delimiter

" hi! link markdownEscape                Special
" hi! link markdownError                 Error
