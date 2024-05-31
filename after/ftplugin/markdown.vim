" compile markdown preview
" :call mkdp#util#install()
nnoremap <leader>md :MarkdownPreview<cr>
nnoremap <leader>st i~~<Esc>A~~<Esc>

let b:ale_fixers = ['prettier']
let b:ale_fix_on_save = 1
let g:mkdp_page_title = '${name}'
let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_fenced_languages = ['bash', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'plaintext', 'markdown']
"vim:wrap

" hi markdowncode #39ff14 000000
" highlight markdownCode guifg=#39ff14 guibg=#000000
" highlight markdownH1   guifg=#FF69FF guibg=#000000
" hi def link markdownH1                    htmlH1
" hi def link markdownH2                    htmlH2
" hi def link markdownH3                    htmlH3
" hi def link markdownH4                    htmlH4
" hi def link markdownH5                    htmlH5
" hi def link markdownH6                    htmlH6
hi Title guifg=#14afff guibg=#000000 gui=bold
hi Delimiter guifg=#ff14af guibg=#000000 gui=bold


" hi def link markdownHeadingRule           markdownRule
" hi def link markdownH1Delimiter           markdownHeadingDelimiter
" hi def link markdownH2Delimiter           markdownHeadingDelimiter
" hi def link markdownH3Delimiter           markdownHeadingDelimiter
" hi def link markdownH4Delimiter           markdownHeadingDelimiter
" hi def link markdownH5Delimiter           markdownHeadingDelimiter
" hi def link markdownH6Delimiter           markdownHeadingDelimiter

" hi def link markdownOrderedListMarker     markdownListMarker
" hi def link markdownListMarker            htmlTagName
" hi def link markdownBlockquote            Comment
" hi def link markdownRule                  PreProc
" hi def link markdownFootnote              Typedef
" hi def link markdownFootnoteDefinition    Typedef
" hi def link markdownIdDeclaration         Typedef
" hi def link markdownLinkText              htmlLink
" hi def link markdownId                    Type
" hi def link markdownUrl                   Float
" hi def link markdownAutomaticLink         markdownUrl
" hi def link markdownUrlTitle              String
" hi def link markdownUrlDelimiter          htmlTag
" hi def link markdownIdDelimiter           markdownLinkDelimiter

" hi def link markdownHeadingDelimiter      Delimiter
" hi def link markdownUrlTitleDelimiter     Delimiter
" hi def link markdownCodeDelimiter         Delimiter

" make normal 39ff14
 hi Normal guifg=#39ff14 guibg=#000000
" " Define a syntax group for regular text
" syn match markdownRegularText ".*"
" " Link the new syntax group to a highlight group
" hi def link markdownRegularText Normal

hi! link Constant Underlined
