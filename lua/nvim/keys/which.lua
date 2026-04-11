return {
  'folke/which-key.nvim',
  -- see icon rules at `$PACKDIR/opt/which-key.nvim/lua/which-key/icons.lua`
  init = function()
    -- local registers = [[*+"-:.%/#=_0123456789]]
    -- package.preload['which-key.plugins.registers'] = function()
    --   local mod =
    --     dofile(vim.g['plug#home'] .. '/which-key.nvim/lua/which-key/plugins/registers.lua')
    --   mod.registers = registers
    --   return mod
    -- end
    -- vim.schedule(function() require('which-key.plugins.registers').registers = registers end)
    local wk = require('which-key')
    wk.setup({
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      replace = {
        desc = {
          -- { '<Plug>%(?(.*)%)?', '%1' },
          { '^%+', '' },
          { '<[cC]md>', ':' },
          { '<[cC][rR]>', '󰌑 ' },
          { '<[sS]ilent>', '' },
          { '^lua%s+', '' },
          { '^call%s+', '' },
          -- { '^:%s*', '' },
        },
      },
      show_help = false,
      sort = { 'order', 'alphanum', 'case', 'mod' },
      spec = {
        { '<leader>?', function() wk.show({ global = false }) end, desc = 'which-key?' },
        { '<C-w><Space>', function() wk.show({ keys = '<C-w>', loop = true }) end },
      },
      { 'gr', group = 'LSP', icon = { icon = '' } },
      -- hide certain, unhelpful mapping hints
      {
        hidden = true,
        { 'g~' },
        -- { 'g#' }, { 'g*' }, { 'gc' }
      },
    })
  end,
}

-- local groups = {
--   { '<leader>b', group = 'buffers' },
--   { '<leader>c', group = 'code' },
--   { '<leader>d', group = 'debug' },
--   { '<leader>dp', group = 'profiler' },
--   { '<leader>f', group = 'file/find' },
--   { '<leader>g', group = 'git' },
--   { '<leader>s', group = 'search' },
--   { '<leader>u', group = 'ui' },
--   { '<localleader>l', group = 'vimtex' },
--   { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
-- }
--
-- -- TODO: move to dedicated cd plugin
-- -- local descriptions = {
-- --   cdc = [[stdpath('config')]],
-- --   cdC = [[stdpath('cache')]],
-- --   cdd = [[stdpath('data')]],
-- --   cds = [[stdpath('state')]],
-- --   gx = 'Open with system app',
-- --   ZQ = ':q!',
-- --   ZZ = ':x',
-- -- }
