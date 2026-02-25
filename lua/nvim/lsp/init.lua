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

local sidekick_copilot_status = function()
  local status
  local ok, statusmod = pcall(require, 'sidekick.status')
  if ok and statusmod then
    status = statusmod.get()
  end
  local kind = status and status.kind or 'Inactive'
  local icon = nv.ui.icons.copilot[kind]
  return icon[1]
  -- FIXME:
  -- local ret = '%$' .. icon[2] .. '$' .. icon[1] .. '%$Chromatophore_b$'
  -- return ret
end

---@param c vim.lsp.Client
M.server_status = function(c)
  if not c or c:is_stopped() then
    return nv.ui.icons.lsp.unavailable
  end
  if c.name == 'copilot' and package.loaded['sidekick'] then
    return sidekick_copilot_status()
  end
  local msg = require('nvim.lsp.progress').get_msgs_by_client_id(c.id)
  if msg then
    return Snacks.util.spinner() .. ' ' -- .. msg
  end
  return nv.ui.icons.lsp.attached
end

---@param buf? number
M.attached = function(buf)
  return vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() })
end

M.status = function()
  local clients = M.attached()
  if #clients == 0 then
    return nv.ui.icons.lsp.unavailable
  end
  return vim.iter(clients):map(M.server_status):join(' ')
end

return M
