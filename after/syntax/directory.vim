if bufname() =~# '/backup$'
  setlocal conceallevel=2
  " hide .bak extension
  syn match directoryBackup /.bak/ conceal cchar=~
  " replace % with / in escaped paths
  syn match directorySlash /%/ conceal cchar=/
endif
