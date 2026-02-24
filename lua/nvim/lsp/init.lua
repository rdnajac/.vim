--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
local M = {}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
}

M.after = function()
  local lsp_config_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'after', 'lsp')
  M.servers = vim.tbl_map(
    function(path) return path:match('^.+/(.+)$'):sub(1, -5) end,
    vim.fn.globpath(lsp_config_dir, '*', false, true)
  )
  vim.lsp.enable(M.servers)

  M.progress = require('nvim.lsp.progress')
  vim.api.nvim_create_autocmd('LspProgress', {
    callback = M.progress.callback,
  })
end

---@param buf? number
M.attached = function(buf)
  vim
    .iter(vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() }))
    :map(function(c) return c.name ~= 'copilot' and c.name or nil end)
    :join(', ')
end

M.server_status = function(id)
  if not id then
    return 'no_id'
  end
  local client = vim.lsp.get_client_by_id(id)
  local status = (client and not client:is_stopped()) and 'attached' or 'unavailable'
  return nv.ui.icons.lsp[status]
end

local sidekick_copilot_status = function()
  local status
  local ok, statusmod = pcall(require, 'sidekick.status')
  if ok and statusmod then
    status = statusmod.get()
  end
  local kind = status and status.kind or 'Inactive'
  local icon = nv.ui.icons.copilot[kind]
  -- return icon[1]
  -- local ret = '%$' .. icon[2] .. '$' .. icon[1] .. '%*'
  -- FIXME:
  local ret = '%$' .. icon[2] .. '$' .. icon[1] .. '%$Chromatophore_b$'
  return ret
end

M.status = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return nv.ui.icons.lsp.unavailable .. ' '
  end
  return vim
    .iter(clients)
    ---@param c vim.lsp.Client
    :map(function(c)
      if c.name == 'copilot' and package.loaded['sidekick'] then
        return sidekick_copilot_status()
      else
        local msgs = require('nvim.lsp.progress').get_msgs_by_client_id(c.id)
        return msgs == '' and nv.ui.icons.lsp.attached or Snacks.util.spinner() .. ' ' .. msgs
      end
    end)
    -- :totable()
    :join(' ')
end

return M
