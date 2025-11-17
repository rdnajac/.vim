local nv = _G.nv or require('nvim.util')

local M = {}

---@type nv.status.Component
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

---@param bufnr? number
---@return string[] List of status icons for the statusline
M.lsp = function(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr or 0 })
  if #clients == 0 then
    return { nv.icons.lsp.unavailable .. ' ' }
  end

  return vim
    .iter(clients)
    :map(function(c)
      if c.name == 'copilot' and package.loaded['sidekick'] then
        local ok, statusmod = pcall(require, 'sidekick.status')
        if ok and statusmod then
          local status = statusmod.get()
          local kind = status and status.kind or 'Inactive'
          return (nv.icons.copilot[kind] or nv.icons.copilot.Inactive)[1]
        end
        return nv.icons.copilot.Inactive[1]
      else
        local icon = nv.icons.lsp.attached
        local msgs = nv.lsp.progress(c.id)
        if #msgs > 0 then
          icon = icon .. ' ' .. table.concat(msgs, ' ')
        end
        return icon
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
    return vim.tbl_map(function(query)
      if query == vim.bo.filetype then
        return ' '
      end
      return nv.icons.filetype[query]
    end, vim.tbl_keys(queries))
  end
  return {}
end

return M
