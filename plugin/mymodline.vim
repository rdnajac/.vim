 "https://www.vim.org/scripts/script.php?script_id=1876
" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
let g:secure_modelines_modelines     = 1
let g:secure_modelines_allowed_items = [
      \ "textwidth",   "tw",
      \ "softtabstop", "sts",
      \ "tabstop",     "ts",
      \ "shiftwidth",  "sw",
      \ "expandtab",   "et",   "noexpandtab", "noet",
      \ "filetype",    "ft",
      \ "foldmethod",  "fdm",
      \ "readonly",    "ro",   "noreadonly",  "noro",
      \ "rightleft",   "rl",   "norightleft", "norl",
      \ "spell",       "nospell", "spelllang", 
      \ "wrap",        "nowrap", 
      \ ]

function! s:DoOne(item) abort
  let l:matches = matchlist(a:item, '^\([a-z]\+\)\%([-+^]\?=[a-zA-Z0-9_\-,.]\+\)\?$')
  if len(l:matches) > 0
    if index(g:secure_modelines_allowed_items, l:matches[1]) != -1
      exec "setlocal " . a:item
    else
      echohl WarningMsg
      echo "Ignoring '" . a:item . "' in modeline"
      echohl None
    endif
  endif
endfun

function! s:DoNoSetModeline(line) abort
  for l:item in split(a:line, '[ \t:]')
    call s:DoOne(l:item)
  endfor
endfun

function! s:DoSetModeline(line) abort
  for l:item in split(a:line)
    call s:DoOne(l:item)
  endfor
endfun

function! s:CheckVersion(op, ver) abort
  if a:op == "="
    return v:version != a:ver
  elseif a:op == "<"
    return v:version < a:ver
  elseif a:op == ">"
    return v:version >= a:ver
  else
    return 0
  endif
endfun

function! s:DoModeline(line) abort
  let l:matches = matchlist(a:line, '\%(\S\@<!\%(vi\|vim\([<>=]\?\)\([0-9]\+\)\?\)\|\sex\):\s*\%(set\s\+\)\?\([^:]\+\):\S\@!')
  if len(l:matches) > 0
    let l:operator = ">"
    if len(l:matches[1]) > 0
      let l:operator = l:matches[1]
    endif
    if len(l:matches[2]) > 0
      if s:CheckVersion(l:operator, l:matches[2]) ? 0 : 1
        return
      endif
    endif
    return s:DoSetModeline(l:matches[3])
  endif

  let l:matches = matchlist(a:line, '\%(\S\@<!\%(vi\|vim\([<>=]\?\)\([0-9]\+\)\?\)\|\sex\):\(.\+\)')
  if len(l:matches) > 0
    let l:operator = ">"
    if len(l:matches[1]) > 0
      let l:operator = l:matches[1]
    endif
    if len(l:matches[2]) > 0
      if s:CheckVersion(l:operator, l:matches[2]) ? 0 : 1
        return
      endif
    endif
    return s:DoNoSetModeline(l:matches[3])
  endif
endfun

function! s:DoModelines() abort
  if line("$") > g:secure_modelines_modelines
    let l:lines={ }
    call map(filter(getline(1, g:secure_modelines_modelines) +
          \ getline(line("$") - g:secure_modelines_modelines, "$"),
          \ 'v:val =~ ":"'), 'extend(l:lines, { v:val : 0 } )')
    for l:line in keys(l:lines)
      call s:DoModeline(l:line)
    endfor
  else
    for l:line in getline(1, "$")
      call s:DoModeline(l:line)
    endfor
  endif
endfun

augroup SecureModeLines
  autocmd!
  autocmd BufRead,StdinReadPost * :call s:DoModelines()
augroup END

" TODO add a function to check shebangs
