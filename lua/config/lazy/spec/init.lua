require('config.lazy.file')

return {
  {
    'LazyVim/LazyVim',
    init = function()
      vim.g.lazyvim_check_order = false
    end,
    priority = 10000,
    opts = {
      -- stylua: ignore
      defaults = { autocmds = false, keymaps = false, },
      news     = { lazyvim  = false, neovim  = false, },
      icons    = {
        diagnostics = {
          Error = '🔥',
          Warn = '💩',
          Hint = '🧠',
          Info = '👾',
        },
      },
    },
    config = function(_, opts)
      require('lazyvim.config').setup(opts)
      LazyVim.on_very_lazy(function()
        require('config.options')
      end)
    end,
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
}
