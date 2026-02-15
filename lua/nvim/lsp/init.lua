local nv = _G.nv or require('nvim.util')
local M = {}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
}

--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
M.capabilities = nil

---@return string[]
M.servers = function()
  -- local lsp_config_dir = vim.fs.joinpath(vim.g.stdpath.config, 'after', 'lsp')
  local lsp_config_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'after', 'lsp')
  return vim.tbl_map(
    function(path) return path:match('^.+/(.+)$'):sub(1, -5) end,
    vim.fn.globpath(lsp_config_dir, '*', false, true)
  )
end

---@param buf? number
M.attached = function(buf)
  vim
    .iter(vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() }))
    :map(function(c) return c.name ~= 'copilot' and c.name or nil end)
    :join(', ')
end

M.status = {
  function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return nv.icons.lsp.unavailable .. ' '
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
      -- :totable()
      :join(' ')
  end,
}

M.after = function() vim.lsp.enable(M.servers()) end

return M
