package.preload['lazydev.config'] = function()
  --- The main function exposed in lazydev topmod
  ---@param buf? integer
  ---@return string? the workspace root if found
  local function find_workspace(buf)
    local fname = vim.api.nvim_buf_get_name(buf or 0)
    local Workspace = require('lazydev.workspace')
    local ws = Workspace.find({ path = fname })
    return ws and ws:root_dir() or nil
  end

  local M = {
    debug = false,
    lua_root = true,
    libs = {}, ---@type lazydev.Library[]
    words = {}, ---@type table<string, string[]>
    mods = {}, ---@type table<string, string[]>
    files = {}, ---@type table<string, string[]>
    is_enabled = function(_) return vim.g.lazydev_enabled ~= false end,
  }

  ---@param opts? lazydev.Config
  function M.setup(opts)
    opts = opts or {}

    for _, lib in pairs(opts.library) do
      lib = type(lib) == 'string' and { path = lib } or lib
      table.insert(M.libs, {
        path = lib.path,
        words = lib.words or {},
        mods = lib.mods or {},
        files = lib.files or {},
      })
    end

    for _, lib in ipairs(M.libs) do
      for _, field in ipairs({ 'words', 'mods', 'files' }) do
        for _, item in ipairs(lib[field]) do
          M[field][item] = M[field][item] or {}
          table.insert(M[field][item], lib.path)
        end
      end
    end
  end

  vim.schedule(function()
    require('lazydev.buf').setup()

    -- require('lazydev.integrations.lspconfig').setup()
    vim.lsp.config('lua_ls', {
      root_dir = function(bufnr, on_dir) on_dir(find_workspace(bufnr)) end,
    })

    local cmd = require('lazydev.cmd')
    vim.api.nvim_create_user_command('LazyDev', cmd.execute, {
      nargs = '*',
      complete = cmd.complete,
      desc = 'lazydev.nvim',
    })
  end)

  return M
end

return {
  'folke/lazydev.nvim',
  opts = {
    library = {
      vim.env.VIMRUNTIME,
      { path = 'nvim', words = { 'nv' } },
      { path = 'mini.nvim', words = { 'Mini.*' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'nvim-lspconfig/lua/lspconfig/types', words = { 'lspconfig' } },
    },
  },
}
