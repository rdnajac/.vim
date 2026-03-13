package.preload['lazydev.config'] = function()
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
    if not opts then
      return
    end
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
    local supported_clients = { 'lua_ls', 'emmylua_ls' }
    for _, server in ipairs(supported_clients) do
      if vim.lsp.is_enabled(server) then
        vim.lsp.config(server, {
          root_dir = function(bufnr, on_dir) on_dir(require('lazydev').find_workspace(bufnr)) end,
        })
      end
    end
    vim.api.nvim_create_user_command(
      'LazyDev',
      function(...) require('lazydev.cmd').execute(...) end,
      {
        nargs = '*',
        complete = function(...) return require('lazydev.cmd').complete(...) end,
        desc = 'lazydev.nvim',
      }
    )
  end)

  return M
end

return {
  'folke/lazydev.nvim',
  opts = {
    library = {
      vim.env.VIMRUNTIME,
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'mini.nvim', words = { 'Mini.*' } },
      { path = 'nvim', words = { 'nv' } },
    },
  },
}
