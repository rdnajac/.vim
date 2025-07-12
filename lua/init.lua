vim.loader.enable()
-- TODO: use this

vim.opt.backupdir:remove('.')
vim.opt.cmdheight = 0
-- vim.opt.laststatus = 3
require('vim._extui').enable({})
require('nvim.autocmds')
require('nvim.diagnostic')
require('nvim.lsp')
require('nvim.munchies')


if vim.env.LAZY ~= nil then
  require('lazy.bootstrap')
  return
end
local Plug = function(name)
  return 'https://github.com/' .. name
end
--
-- -- TODO: /Users/rdn/.local/share/nvim/site/pack/core/opt/snacks.nvim/lua/snacks/init.lua
-- -- see: `load`
--   local events = {
--     BufReadPre = { "bigfile", "image" },
--     BufReadPost = { "quickfile", "indent" },
--     BufEnter = { "explorer" },
--     LspAttach = { "words" },
--     UIEnter = { "dashboard", "scroll", "input", "scope", "picker" },
--   }
--
--   ---@param event string
--   ---@param ev? vim.api.keyset.create_autocmd.callback_args
--   local function load(event, ev)
--     local todo = events[event] or {}
--     events[event] = nil
--     for _, snack in ipairs(todo) do
--       if M.config[snack] and M.config[snack].enabled then
--         if M[snack].setup then
--           M[snack].setup(ev)
--         elseif M[snack].enable then
--           M[snack].enable()
--         end
--       end
--     end
--   end
--
--   if vim.v.vim_did_enter == 1 then
--     M.did_setup_after_vim_enter = true
--     load("UIEnter")
--   end
--
--   local group = vim.api.nvim_create_augroup("snacks", { clear = true })
--   vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
--     group = group,
--     once = true,
--     nested = true,
--     callback = function(ev)
--       load(ev.event, ev)
--     end,
--   })

-- ~/.local/share/nvim/site/pack/core/opt/
vim.pack.add({
  -- libraries
  Plug('nvim-lua/plenary.nvim'),
  Plug('echasnovski/mini.nvim'),
  Plug('folke/snacks.nvim'),
  -- ui
  Plug('folke/tokyonight.nvim'),
  Plug('folke/which-key.nvim'),
  -- editing
  Plug('Saghen/blink.cmp'),
  Plug('monaqa/dial.nvim'),
  -- meta
  Plug('stevearc/oil.nvim'),
  Plug('xvzc/chezmoi.nvim'),
  Plug('folke/lazydev.nvim'),
  -- lang
  Plug('mason-org/mason.nvim'),
  {
    src = Plug('nvim-treesitter/nvim-treesitter'),
    version = 'main',
  },
  Plug('folke/ts-comments.nvim'),
})

require('plugins.snacks').config()
require('plugins.oil').config()
require('plugins.mini').config()
require('plugins.which-key').config()
require('plugins.mason').config()
require('plugins.lazydev').config()
-- TODO: move spec to plugins?
require('nvim.colorscheme')
require('nvim.treesitter')

local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
function _G.lazyload(fn)
  vim.api.nvim_create_autocmd('VimEnter', {
    group = aug,
    once = true,
    callback = fn,
  })
end

lazyload(function()
  vim.cmd([[ aunmenu PopUp | autocmd! nvim.popupmenu ]])
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
  -- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
  vim.opt.foldexpr = 'v:lua.require("nvim.treesitter.fold").expr()'
  vim.opt.jumpoptions = 'view,stack'
  vim.opt.mousescroll = 'hor:0'
  vim.opt.pumblend = 0
  vim.opt.smoothscroll = true
  require('plugins.blink').config()
  require('plugins.dial').config()
  require('nvim.ui.chromatophore')
  require('nvim.keymaps')
end)
