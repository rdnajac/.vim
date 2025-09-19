local M = {
  'folke/flash.nvim',
  enabled = false,
  opts = {},
}
-- stylua: ignore
M.keys = {
  { 'gj', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
  { 's', mode = { 'n', 'o', 'x' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
  { 'J', mode = 'o',             function() require('flash').remote() end, desc = 'Remote Flash' },
  { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
  { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
}

M.after = function()
  vim.keymap.set({ 'n', 'x', 'o' }, '<c-space>', function()
    require('flash').treesitter({
      actions = {
        ['<c-space>'] = 'next',
        ['<BS>'] = 'prev',
      },
    })
  end, { desc = 'Treesitter incremental selection' })
end

return M
