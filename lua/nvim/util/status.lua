local nv = _G.nv or require('nvim.util')

local M = {}

M.blink = function()
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok or not sources then
    return ''
  end

  return vim
    .iter(vim.tbl_keys(sources.get_enabled_providers('default')))
    :map(function(key)
      return nv.icons.src[key]
    end)
    :join(' ')
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

M.term = function()
  if vim.bo.buftype ~= 'terminal' then
    return nil
  end
  local icon = (vim.g.ooze_channel ~= nil and vim.g.ooze_channel == vim.bo.channel) and ' '
    or ' '
  return ' ' .. icon .. vim.bo.channel
end

M.lsp = nv.lsp.status
M.treesitter = nv.treesitter.status

M.status = function()
  local parts = {
    ' B󰐣 %n',
    'TS ' .. M.treesitter(),
    'LSP ' .. M.sidekick() .. ' ' .. M.lsp(),
    vim.fn.mode():sub(1, 1) == 'i' and M.blink() or nil,
  }
  return table.concat(parts, '  ')
end

return setmetatable(M, {
  __call = function()
    return M.status()
  end,
})
