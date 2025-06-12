require('lazy.file')

return {
  {
    'LazyVim/LazyVim',
    priority = 10000,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.config')

      LazyVim.track('colorscheme')
      require('tokyonight').load()
      LazyVim.track()

      LazyVim.on_very_lazy(function()
        if lazy_autocmds then
          require('config.autocmds')
        end
        require('nvim.keymaps')
        require('nvim.options')
        vim.cmd([[do VimResized]])

        LazyVim.format.setup()
        LazyVim.root.setup()
      end)
    end,
  },
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
  { 'nvim-lua/plenary.nvim', lazy = true },
}
