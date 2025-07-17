return function()
  local ok, oil = pcall(require, 'oil')
  if ok then
    return vim.fn.fnamemodify(oil.get_cursor_entry(), ':~')
  else
    return ''
  end
end
