package.preload['lazydev.config'] = function()
  ---@type lazydev.Config.mod
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
    for _, lib in pairs(opts and opts.library or {}) do
      lib = type(lib) == 'string' and { path = lib } or lib
      table.insert(M.libs, {
        path = lib.path,
        words = lib.words or {},
        mods = lib.mods or {},
        files = lib.files or {},
      })
    end
    for _, lib in ipairs(M.libs) do
      -- for _, field in ipairs({ 'words', 'mods', 'files' }) do
      for _, field in ipairs({ 'words' }) do
        for _, item in ipairs(lib[field]) do
          M[field][item] = M[field][item] or {}
          table.insert(M[field][item], lib.path)
        end
      end
    end
  end

  return M
end

vim.schedule(function()
  -- set up the plugin and configure paths
  require('lazydev.config').setup({
    library = {
      vim.env.VIMRUNTIME,
      { path = 'mini.nvim', words = { 'Mini.*' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'nvim-lspconfig/lua/lspconfig/types', words = { 'lspconfig' } },
    },
  })
  -- register autocmds for attaching to buffers
  require('lazydev.buf').setup()
  -- override the default command to always work as `LazyDev debug`
  vim.cmd([[command! LazyDev lua require('lazydev.cmd').commands.debug()]])
end)

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir) on_dir(require('lazydev').find_workspace(bufnr)) end,
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      completion = { autoRequire = false },
      diagnostics = { disable = { 'missing-fields' } },
      hover = {
        previewFields = 255,
      },
    },
  },
}
