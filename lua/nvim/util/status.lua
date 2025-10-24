---@class nv.status.Component
---@field [1] fun():string[]|string[]
---@field cond? fun():boolean
---@field color? any

local nv = _G.nv or require('nvim.util')
local icons = nv.icons

local M = {}

M.buffer = function()
  if vim.bo.buftype == 'terminal' then
    return [[ %{&channel}]]
  end
  return "%{% &buflisted ? '%n' : '󱪟 ' %}" .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
end

---@type nv.status.Component
M.blink = {
  function()
    return vim.tbl_map(icons.blink, nv.blink.get_providers())
  end,
  cond = function()
    return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i'
  end,
}

M.diagnostic = {
  ---@param bufnr? number
  ---@return string
  function(bufnr)
    bufnr = bufnr or 0
    local counts = vim.diagnostic.count(bufnr)
    local signs = vim.diagnostic.config().signs
    return vim
      .iter(pairs(counts))
      :map(function(severity, count)
        return string.format(
          '%%#%s#%s:%d%%*',
          signs and signs.numhl[severity] or '',
          signs and signs.text[severity] or '',
          count or ''
        )
      end)
      :join('')
  end,
  cond = function(bufnr)
    return not vim.tbl_isempty(vim.diagnostic.count(bufnr or 0))
  end,
}

---@return string[] List of status icons for the statusline
M.lsp = function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    return { icons.lsp.unavailable .. ' ' }
  end

  return vim
    .iter(clients)
    :map(function(c)
      if c.name == 'copilot' and package.loaded['sidekick'] then
        local ok, statusmod = pcall(require, 'sidekick.status')
        if ok and statusmod then
          local status = statusmod.get()
          local kind = status and status.kind or 'Inactive'
          return (icons.copilot[kind] or icons.copilot.Inactive)[1]
        end
        return icons.copilot.Inactive[1]
      else
        return icons.lsp.attached
      end
    end)
    :totable()
end

---@param bufnr? number
---@return string[]
M.treesitter = function(bufnr)
  local highlighter = require('vim.treesitter.highlighter')
  local hl = highlighter.active[bufnr or vim.api.nvim_get_current_buf()]
  ---@diagnostic disable-next-line: invisible
  local queries = hl and hl._queries
  if type(queries) == 'table' then
    return vim.tbl_map(icons.filetype, vim.tbl_keys(queries))
  end
  return {}
end

return setmetatable(M, {
  __call = function()
    return M.status()
  end,
})
