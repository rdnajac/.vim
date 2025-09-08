vim.g.rout_follow_colorscheme = true

local M = {
  'R-nvim/R.nvim',
  name = 'r',
  -- src = 'R-nvim/R.nvim',
  -- name = 'R.nvim',
  ft = { 'r', 'rmd', 'quarto' },
  ---@type RConfigUserOpts
  opts = {
    R_args = { '--quiet', '--no-save' },
    pdfviewer = '',
    user_maps_only = true,
    quarto_chunk_hl = { highlight = false },
  },
}

-- M.config = function()
-- require('r').setup(M.opts)
-- vim.schedule(function()
--   require('cmp_r').setup({})
-- end)
-- require('which-key').add({
--   { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
--   { '<localleader>R', '<Plug>RStart', ft = M.filetypes },
-- })
-- end

return M
