local M = {}

M.after = function() vim.lsp.enable(M.servers()) end

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

M.server_status = function(id)
  local client = vim.lsp.get_client_by_id(id)
  local status = (client and not client:is_stopped()) and 'attached' or 'unavailable'
  return nv.ui.icons.lsp[status]
end

M.status = {
  function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return nv.ui.icons.lsp.unavailable .. ' '
    end

    return vim
      .iter(clients)
      :map(function(c)
        if c.name == 'copilot' and package.loaded['sidekick'] then
          local status
          local ok, statusmod = pcall(require, 'sidekick.status')
          if ok and statusmod then
            status = statusmod.get()
          end
          local kind = status and status.kind or 'Inactive'
          return (nv.ui.icons.copilot[kind])[1]
        else
          local icon = nv.ui.icons.lsp.attached
          local msgs = require('nvim.lsp.progress')(c.id)
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

return M
