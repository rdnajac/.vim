vim.loader.enable()

function _G.Lazy(fn)
  vim.api.nvim_create_autocmd('UIEnter', {
    group = vim.api.nvim_create_augroup('LazyLoad', { clear = true }),
    once = true,
    callback = fn,
  })
end

if vim.env.LAZY ~= nil then
  require('lazy.bootstrap')
else
  local Plug = function(name)
    return 'https://github.com/' .. name
  end

  -- ~/.local/share/nvim/site/pack/core/opt/
  vim.pack.add({
    Plug('nvim-lua/plenary.nvim'),
    Plug('echasnovski/mini.nvim'),
    Plug('xvzc/chezmoi.nvim'),
    Plug('folke/snacks.nvim'),
    Plug('folke/which-key.nvim'),
    Plug('folke/tokyonight.nvim'),
    Plug('monaqa/dial.nvim'),
    Plug('stevearc/oil.nvim'),
    Plug('Saghen/blink.cmp'),
    Plug('folke/ts-comments.nvim'),
    Plug('mason-org/mason.nvim'),
    Plug('folke/lazydev.nvim'),
    {
      src = Plug('nvim-treesitter/nvim-treesitter'),
      version = 'main',
    },
  })

  require('tokyonight').load(require('nvim.ui.tokyonight'))
  require('oil').setup(require('plugins.oil.init').opts())
  require('nvim.munchies')
  require('plugins.mini')
  require('plugins.snacks')
  require('lang')
end
