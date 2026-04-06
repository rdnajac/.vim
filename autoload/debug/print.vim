function! debug#print#lua() abort
  let word = substitute(expand('<cWORD>'), ',$', '', '')
  if getline('.') =~# 'function'
    let word .= '()'
  endif
  call append(line('.'), printf('print(%s)', word))
endfunction

" M.print = function()
"   local ft = vim.bo.filetype
"   local row = vim.api.nvim_win_get_cursor(0)[1]
"   local word = vim.fn.expand('<cWORD>'):gsub(',$', '') -- trim trailing comma
"   local templates = {
  "     vim = ([[echom %s]]):format(word),
  "   }
  "   if vim.tbl_contains(vim.tbl_keys(templates), ft) then
  "     vim.api.nvim_buf_set_lines(0, row, row, true, { templates[ft] })
  "   end
  " end
