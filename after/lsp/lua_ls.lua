Plug('folke/lazydev.nvim')
local function lazydev()
  -- set up the plugin and configure paths
  package.preload['lazydev.config'] = function()
    return nv.lsp.lazydev
  end
  require('lazydev.config').setup({
    library = {
      vim.env.VIMRUNTIME,
      { path = 'mini.nvim', words = { 'Mini.*' } },
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = 'nvim-lspconfig/lua/lspconfig/types', words = { 'lspconfig' } },
    },
  })
  require('lazydev.buf').setup() -- creates autocmds
  -- override the default command so it is always `LazyDev debug`
  vim.cmd([[command! LazyDev lua require('lazydev.cmd').commands.debug()]])
end

vim.schedule(lazydev)

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    on_dir(require('lazydev').find_workspace(bufnr))
  end,
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      completion = { autoRequire = false },
      diagnostics = { disable = { 'missing-fields' } },
      hover = { previewFields = 255 },
    },
  },
}
