function! GxSmart() abort
  let line = getline('.')
  let col = col('.')
  let match = matchlist(line, '\v[''"](\w[-\w_]*/[\w_.-]+)[''"]')
  if !empty(match)
    echom "Opening URL: " . match[1]
    let url = match[1]
    let start = matchstrpos(line, url)[0] + 1
    let end = start + strlen(url) - 1
    if col >= start && col <= end
      execute 'silent! !open https://github.com/' . url
      return
    endif
  endif
  echom "No valid URL found at cursor position."
  normal! gx
endfunction

" nnoremap gx :call GxSmart()<CR>

" LazyVim/LazyVim
" https://google.com
" google.com
