return {
  'folke/lazydev.nvim',
  -- enabled = false,
  ft = { 'lua' },
  config = function()
    -- HACK: correctly identify the name of the lsp client
    package.preload['lazydev.lsp'] = function()
      local lazydev_path = vim.g.plug_home .. '/lazydev.nvim/'
      local mod = dofile(lazydev_path .. '/lua/lazydev/lsp.lua')
      local orig_supports = mod.supports

      mod.supports = function(client)
        return client and client.name == 'luals' or orig_supports(client)
      end
      return mod
    end

    require('lazydev.config').setup({
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    })
  end,
}
