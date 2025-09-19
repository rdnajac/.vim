local M = {
  ---@alias lazydev.Library {path:string, words:string[], mods:string[], files:string[]}
  ---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[], files?:string[]}
  ---@type lazydev.Library.spec[]
  library = {
    { path = vim.env.VIMRUNTIME },
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = vim.fs.joinpath(vim.g.plug_home, 'snacks/lua/snacks'), words = { 'Snacks' } },
    { path = vim.fs.joinpath(vim.fn.stdpath('config'), 'bin') },
    -- { path = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim'), words = { 'nv' } },
    -- { path = vim.fn.stdpath('config') .. '/lua', words = { 'nvim' } },
  },
  config = function()
    require('nvim.lsp.lazydev.buf').setup()

    -- originally from `lazydev/integrations/lspconfig.lua`
    if vim.lsp.is_enabled('luals') then
      vim.lsp.config('luals', {
        root_dir = function(bufnr, on_dir)
          on_dir(require('lazydev').find_workspace(bufnr))
        end,
      })
    end

    vim.api.nvim_create_user_command('LazyDev', function(opts)
      require('nvim.lsp.lazydev.cmd')[opts.args]()
    end, {
      nargs = 1,
      complete = function()
        return { 'debug', 'lsp' }
      end,
      desc = 'Run lazydev command (debug or lsp)',
    })
  end,
  debug = false,
  enabled = function(_) -- root_dir
    return vim.g.lazydev_enabled ~= false
  end,
}

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
