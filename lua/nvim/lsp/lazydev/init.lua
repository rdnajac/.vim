local M = {}

---@alias lazydev.Library {path:string, words:string[], mods:string[], files:string[]}
---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[], files?:string[]}
---@type lazydev.Library.spec[]
M.library = {
  { path = vim.env.VIMRUNTIME },
  { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  -- { path = 'snacks.nvim', words = { 'Snacks' } },
  { path = vim.g.plug_home .. '/snacks.nvim', words = { 'Snacks' } },
  -- { path = 'nvim', words = { 'nvim' } }, -- FIXME: doesn't work
}

M.enabled = function(root_dir)
  return vim.g.lazydev_enabled ~= false
end

M.debug = false

vim.api.nvim_create_user_command('LazyDev', function(opts)
  local cmd = opts.args
  require('nvim.lsp.lazydev.cmd')[cmd]()
end, {
  nargs = 1,
  complete = function()
    return { 'debug', 'lsp' }
  end,
  desc = 'Run lazydev command (debug or lsp)',
})

vim.schedule(function()
  require('nvim.lsp.lazydev.buf').setup()
  require('nvim.lsp.lazydev.lspconfig').setup()
end)

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
