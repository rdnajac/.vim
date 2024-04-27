" vim:ft=vim :wrap
nnoremap <leader>md :MarkdownPreview<cr>
setlocal wrap spell spl=en_us cole=2
let g:vim_markdown_fenced_languages = ['bash=sh', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'dockerfile', 'plaintext', 'markdown']
let g:vim_markdown_math = 1

" why is this so incredibly annoying?
let g:vim_markdown_folding_disabled = 1

" DIY
function! MarkdownLevel()
    if !exists('b:in_code_fence')
        let b:in_code_fence = 0
    endif

    let line = getline(v:lnum)
    if line =~ '^```'
        let b:in_code_fence = !b:in_code_fence
    endif

    if !b:in_code_fence
        let h = matchstr(line, '^\#\+\s')
        if !empty(h)
            return ">" . (len(h) - 1)
        endif
    endif

    return "="
endfunction

setlocal fde=MarkdownLevel() fdm=expr fdl=2
