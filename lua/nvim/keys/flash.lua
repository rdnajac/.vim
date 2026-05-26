return {
  'folke/flash.nvim',
  opts = {},
  keys = function()
    local flash = require('flash')
    return {
      { { 'n' }, 'F', flash.jump, {} },
      { { 'o', 'x', 'n' }, '<C-J>', flash.jump, {} },
      { { 'o', 'x' }, '<C-F>', flash.treesitter, {} },
      { { 'o', 'x' }, 'R', flash.treesitter_search, {} },
      { { 'o' }, 'r', flash.remote, {} },
      { { 'c' }, '<C-F>', flash.toggle, {} },
    }
  end,
}
