local M = {}

---@alias lazydev.Library {path:string, words:string[], mods:string[], files:string[]}
---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[], files?:string[]}
---@type lazydev.Library.spec[]
M.library = {
  { path = vim.env.VIMRUNTIME },
  { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  { path = vim.fs.joinpath(vim.g.plug_home, 'snacks/lua/snacks'), words = { 'Snacks' } },
  -- { path = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim'), words = { 'nv' } },
}

M.enabled = function(root_dir)
  return vim.g.lazydev_enabled ~= false
end

M.debug = false

vim.api.nvim_create_user_command('LazyDev', function(opts)
  require('nvim.lsp.lazydev.cmd')[opts.args]()
end, {
  nargs = 1,
  complete = function()
    return { 'debug', 'lsp' }
  end,
  desc = 'Run lazydev command (debug or lsp)',
})

vim.schedule(function()
  require('nvim.lsp.lazydev.buf').setup()
  -- M.lspconfig()
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

function M.lspconfig()
  local ok, Manager = pcall(require, 'lspconfig.manager')
  if not ok then
    return
  end

  local try_add = Manager.try_add

  --- @param buf integer
  --- @param project_root? string
  function Manager:try_add(buf, project_root)
    local is_supported = false
    for _, ids in pairs(self._clients) do
      for _, client_id in ipairs(ids) do
        local client = vim.lsp.get_client_by_id(client_id)
        if client and client.name == 'luals' then
          is_supported = true
          break
        end
      end
    end
    -- TODO: should this be moved?
    if is_supported and not project_root then
      local root = require('nvim.lsp.lazydev').find_workspace(buf)
      if root then
        return self:add(root, false, buf)
      end
    end
    return try_add(self, buf, project_root)
  end
end

return M
