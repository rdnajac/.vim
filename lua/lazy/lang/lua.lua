langsetup({ { 'lua-language-server', 'luals' }, 'stylua' })

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      -- stylua: ignore
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'LazyVim',            words = { 'LazyVim' } },
        { path = 'snacks.nvim',        words = { 'Snacks' } },
        { path = 'lazy.nvim',          words = { 'LazyVim' } },
      },
    },
    config = function(_, opts)
      -- HACK: fix lsp name mismatch
      local lazydev_path = require('lazy.core.config').spec.plugins['lazydev.nvim'].dir
      package.preload['lazydev.lsp'] = function()
        local mod = dofile(lazydev_path .. '/lua/lazydev/lsp.lua')
        local orig_supports = mod.supports
        mod.supports = function(client)
          -- correcrly identify the name of the lsp client
          if client and vim.tbl_contains({ 'luals' }, client.name) then
            return true
          end
          return orig_supports(client)
        end
        return mod
      end

      require('lazydev.config').setup(opts)
    end,
  },
}
