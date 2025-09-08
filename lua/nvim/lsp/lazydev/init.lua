local M = {}

M.opts = {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'snacks.nvim', words = { 'Snacks' } },
    -- { path = 'nvim', words = { 'nvim' } }, -- FIXME: doesn't work
  },
}

---@param opts? lazydev.Config
function M.setup()
  -- vim.api.nvim_create_autocmd('FileType', {
  --   group = vim.api.nvim_create_augroup('LazyDevSetup', { clear = true }),
  --   pattern = 'lua',
  --   once = true,
  --   callback = function(args)
  --     info('setting up lazydev for lua filetype')
  --     require('nvim.lsp.lazydev.config').setup(M.opts)
  --   end,
  -- })
  require('nvim.lsp.lazydev.config').setup(M.opts)
end

--- Checks if the current buffer is in a workspace:
--- * part of the workspace root
--- * part of the workspace libraries
--- Returns the workspace root if found
---@param buf? integer
function M.find_workspace(buf)
  local fname = vim.api.nvim_buf_get_name(buf or 0)
  local Workspace = require('nvim.lsp.lazydev.workspace')
  local ws = Workspace.find({ path = fname })
  return ws and ws.root or nil
end

return M
