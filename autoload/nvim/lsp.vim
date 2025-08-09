function nvim#lsp#root() abort
  if has('nvim')
    return luaeval('vim.lsp.buf.list_workspace_folders()[1] or ""')
  endif
  return ''
endfunction
