  function! s:singlequote(str)
    return "'"..substitute(copy(a:str), "'", "''", 'g').."'"
  endfunction

  " a robust way to create cmdline abbreviations
  " TODO: maybe check getcmdline() =~# "%s"
  function! cmd#abbrev(lhs, rhs)
    execute printf(
	  \ 'cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
	  \ a:lhs, 1+len(a:lhs), s:singlequote(a:rhs), s:singlequote(a:lhs))
  endfunction

" create an ephemeral buffer containing the clipboard contents
" on write, yank the buffer contents to the clipboard and delete the buffer
  " `https://github.com/neovim/neovim/discussions/38256`
  " Usage: $`nvim +Clipboard` or `alias pbedit='nvim +Clipboard'`
function! cmd#clipboard() abort
  edit +setl\ bt=acwrite\ bh=wipe\ nobl\ noswf Clipboard
  silent execute 'put +|1d _'
  autocmd BufWriteCmd <buffer> %yank + | set nomodified'
endfunction

function! s:diffthese() abort
  diffthis | wincmd p |diffthis
endfunction

if exists(':DiffOrig') != 2
  command DiffOrig vnew +set\ bt=nofile | r ++edit # | 0d_ | call s:diffthese()
endif

function! cmd#diff(...) abort
  let winnr = winnr('$')

  if a:0 == 0
    if winnr == 1
      DiffOrig
    elseif winnr('$') == 2
      if exists(':DiffTool') == 2
	let b1 = fnamemodify(bufname(winbufnr(1)), ':p')
	let b2 = fnamemodify(bufname(winbufnr(2)), ':p')
	echom 'Using DiffTool to compare: ' . b1 . ' and ' . b2
	execute 'DiffTool' b1 b2
      else
	call s:diffthese()
      endif
    else
      echoerr 'Exactly two windows must be open.'
    endif

  elseif a:0 == 1
    if winnr == 1
      execute 'vert sbuffer' a:1
      call s:diffthese()
    endif

  elseif a:0 == 2
    let abspath1 = fnamemodify(bufname(a:1), ':p')
    let abspath2 = fnamemodify(bufname(a:2), ':p')
    execute 'DiffTool' abspath1 abspath2
  endif
endfunction

 " TODO: use `jobstart` to avoid the Snacks dependency
function cmd#hardcopy() abort
  lua Snacks.terminal.open(([[vim -esNu NONE %s -c 'hardcopy | q!']]):format(vim.api.nvim_buf_get_name(0)))
endfunction

function! cmd#scp(dest) abort
  if !executable('scpp')
    echoerr 'scp command not found'
    return
  endif

  if a:dest == ''
    echoerr 'Usage: :Scp user@host[:/remote/path]'
    return
  endif

  let target = a:dest =~ ':' ? a:dest : a:dest . ':~/'
  write
  execute '!scp % ' . shellescape(target)
endfunction

function! cmd#scp_complete(A, L, P) abort
  let all = split(system("grep '^Host\\>' ~/.ssh/config | awk '{print $2}'"), "\n")
  return filter(all, 'v:val =~? "^" . a:A')
endfunction
