local nv = _G.nv or require('nvim.util')
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

M.sidekick = function()
  local ok, statusmod = pcall(require, 'sidekick.status')
  local status = ok and statusmod and statusmod.get() or nil
  local kind = status and status.kind or 'Inactive'
  return (nv.icons.copilot[kind] or nv.icons.copilot.Inactive)[1]
end

M.lsp = nv.lsp.status
M.treesitter = nv.treesitter.status

M.status = function()
  local parts = {
    M.treesitter(),
    M.lsp(),
    M.sidekick(),
    M.diagnostic(),
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
