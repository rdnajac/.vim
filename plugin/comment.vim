" plugin/comment.vim
function! s:map_insert_comment(lhs, tag) abort
  execute 'nnoremap cO' . a:lhs . ' :call comment#above("' . a:tag . '")<CR>'
  execute 'nnoremap co' . toupper(a:lhs) . ' :call comment#above("' . a:tag . '")<CR>'
  execute 'nnoremap co' . a:lhs . ' :call comment#below("' . a:tag . '")<CR>'
endfunction

call s:map_insert_comment('o', '')
call s:map_insert_comment('t', 'TODO')
call s:map_insert_comment('f', 'FIXME')
call s:map_insert_comment('h', 'HACK')
call s:map_insert_comment('b', 'BUG')
call s:map_insert_comment('p', 'PERF')
call s:map_insert_comment('x', 'XXX')

if !has('nvim')
  " see `:h package-comment`
  packadd comment
  " XXX: does not work with the version of vim that comes with homebrew
  " `VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Feb 21 2025 00:05:49)`
  "see: `https://github.com/vim/vim/commit/fa6300872732f80b770a768e785ae2b189d3e684`
endif
