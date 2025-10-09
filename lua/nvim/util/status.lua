local M = {}

M.diagnostic = function()
  local counts = vim.diagnostic.count(0)
  local signs = vim.diagnostic.config().signs

  if not signs or vim.tbl_isempty(counts) then
    return ''
  end

  return vim
    .iter(pairs(counts))
    :map(function(severity, count)
      return string.format('%%#%s#%s:%d', signs.numhl[severity], signs.text[severity], count)
    end)
    :join('')
end

for name in ('blink lsp sidekick'):gmatch('%S+') do
  M[name] = require('nvim.plugins.' .. name).status
end

M.lsp = require('nvim.util.lsp').status
M.treesitter = require('nvim.util.treesitter').status

M.status = function()
  local parts = {
    M.treesitter(),
    M.lsp(),
    M.sidekick(),
    M.diagnostic(),
    ' %#Chromatophore_b#',
  }

  if vim.fn.mode():sub(1, 1) == 'i' then
    table.insert(parts, M.blink()) -- put blink first
  end

  return table.concat(parts)
end

return setmetatable(M, {
  __call = function()
    return M.status()
  end,
})
