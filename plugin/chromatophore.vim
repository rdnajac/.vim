augroup chromatophore
  autocmd!
  autocmd ColorScheme,ModeChanged,VimEnter * call chromatophore#setup()
  " HACK:
  " au FileType snacks_dashboard lua vim.schedule(function() vim.cmd('doautocmd ColorScheme') end)
augroup END

if v:vim_did_enter
  call chromatophore#setup()
endif
