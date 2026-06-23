_G.lua_tagfunc = function(pattern, flags)
  local tags = vim.lsp.tagfunc(pattern, flags)
  if type(tags) ~= 'table' or #tags <= 1 then
    return tags
  end
  local filtered = vim.tbl_filter(function(entry)
    -- dont match lua-language-server meta stubs when a real def exists
    return not entry.filename:match('lua%-language%-server')
  end, tags)
  return #filtered > 0 and filtered or tags
end

vim.bo.tagfunc = 'v:lua.lua_tagfunc'
