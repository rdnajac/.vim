local M = {}

---@param opts LazyConfig
function M.load(opts)
  opts = vim.tbl_deep_extend('force', {
    spec = {
      -- { dir = vim.fn.stdpath('config') .. '/ooze', lazy=false },
      { import = 'config.lazy.vim' },
      { import = 'config.lazy.spec' },
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    rocks = { enabled = false },
    install = { colorscheme = { 'tokyonight' } },
    change_detection = { notify = false },
    ui = {
      border = 'rounded',
      custom_keys = {
        ['<localleader>d'] = function(plugin)
          dd(plugin)
        end,
      },
    },
    performance = {
      rtp = {
        -- paths = { vim.fn.stdpath('config') .. '/pack/tpope/start' },
        disabled_plugins = {
          'gzip',
          -- 'matchit',
          -- 'matchparen',
          -- 'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }, opts or {})
  ddd('lazy setup pre')
  require('lazy').setup(opts)
  ddd('lazy setup post')
end

return M
