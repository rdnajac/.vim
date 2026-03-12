--- `capabilities = require('blink.cmp').get_lsp_capabilities()`,
--- see `:h vim.lsp.protocol.make_client_capabilities()` for defaults
local M = {}

M.specs = {
  'neovim/nvim-lspconfig',
  -- 'b0o/SchemaStore.nvim',
  {
    'folke/lazydev.nvim',
    opts = {
      -- integrations = { cmp = false },
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.nvim', words = { 'Mini.*' } },
        { path = 'nvim', words = { 'nv' } },
      },
    },
  },
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

local copilot_status = function()
  local status
  if package.loaded['sidekick'] then
    local sidekick_status = require('sidekick.status').get()
    if sidekick_status then
      status = sidekick_status.busy == true and 'Warning' or sidekick_status.kind
    end
  else
    -- FIXME:
    status = 'Normal'
  end
  local icon = nv.ui.icons.copilot[status or 'Inactive']
  return icon[1] .. ' '
end

---@param c vim.lsp.Client
M.server_status = function(c)
  if c.name == 'copilot' then
    return copilot_status()
  end
  local status
  if c:is_stopped() then
    status = 'stopped'
  else
    local msg = M.progress.get_msgs_by_client_id(c.id)
    if msg then
      return nv.util.spinner() .. ' '
      -- status = 'busy'
    end
  end
  return nv.ui.icons.status[status or 'active'] .. ' '
end

---@param buf? number
M.attached = function(buf)
  return vim.lsp.get_clients({ bufnr = buf or vim.api.nvim_get_current_buf() })
end

M.status = function() return vim.iter(M.attached()):map(M.server_status):join(' ') end

return M
