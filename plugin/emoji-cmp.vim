finish
let s:emoji_path = expand('~/.vim/.emoji.json')
let s:emoji_file = 'https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json'

if !filereadable(s:emoji_path)
  silent! execute 'curl -L -o ' . s:emoji_path . ' ' . s:emoji_file
  if v:shell_error
    echo 'Failed to download emoji.json'
    finish
  endif
endif

let emoji_json = join(readfile(s:emoji_path), "\n")

function! s:to_candidate(emoji)
  return has_key(a:emoji, 'emoji') ? {
        \ 'emoji': a:emoji['emoji'],
        \ 'word': a:emoji['aliases'][0],
        \ 'kind': a:emoji['emoji'] . ' ',
        \ 'menu': a:emoji['description'],
        \ 'icase': 1,
        \ 'dup': 1
        \ } : {}
endfunction

let s:emojis = map(json_decode(emoji_json), 's:to_candidate(v:val)')

function! s:complete(findstart, base)
  if a:findstart
    return match(getline('.')[0:col('.') - 1], ':[^: \t]*$')
  elseif empty(a:base)
    return s:emojis
  else
    let matches = filter(copy(s:emojis), 'stridx(v:val.word, a:base[1:]) >= 0')
    return matches
  endif
endfunction

function! s:emoji_expand()
  if !exists('b:complete_start')
    return
  endif
  let line = getline('.')
  let pre = line[:b:complete_start-1]
  let query = line[b:complete_start:col('.')-2]
  let post = line[col('.')-1:]
  for emoji in s:emojis
    if query == emoji['word']
      call setline('.', pre . emoji['emoji'] . post)
      call cursor('.', len(pre . emoji['emoji']) + 1)
      return
    endif
  endfor
endfunction
inoremap <silent><expr> <c-,> s:complete(1, '')
:dna

augroup emoji_complete_done
  autocmd!
  autocmd CompleteDone <buffer> call s:emoji_expand()
augroup END

