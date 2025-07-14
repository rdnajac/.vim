" E841: Reserved name, cannot be used for user defined command
" However, Support for editing encrypted files has been removed in neovim
if has('nvim')
  command! -nargs=+ X call append('$', Append(<f-args>))
endif

command! -nargs=+ Append call append('$', Append(<f-args>))

function! Append(...) abort
  let args = a:000
  if args[0] == '!'
    let cmd = join(args[1:], ' ')
    return split(system(cmd), "\n")
  else
    return split(execute(join(args, ' ')), "\n")
  endif
endfunction

nnoremap <leader>A Append

function! XCmdline() abort
  let cmdline = getcmdline()
  if empty(cmdline) || getcmdtype()  != ':'
    return '<M-CR>'
  else
    call feedkeys("\<C-c>", 'n')
    call timer_start(0, {-> execute('call redir#execute("' . escape(cmdline, '"') . '")')})
  endif
endfunction

cnoremap <expr> <M-CR> XCmdline()
