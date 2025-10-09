local M = {}

M.blink = function()
  local ret = ''
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if ok and sources then
    for _, key in ipairs(vim.tbl_keys(sources.get_enabled_providers('default'))) do
      ret = ret .. nv.icons.src[key] .. ' '
    end
  end
  return ret
end


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

M.lsp = require('nvim.util.lsp').status
M.sidekick = require('nvim.plugins.sidekick').status
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
