if bufname() =~# 'backup'
  " hide .bak extension
  syn match directoryBackup /.bak/ conceal
  " replace % with / in escaped paths
  syn match directorySlash /%/ conceal cchar=/
endif
