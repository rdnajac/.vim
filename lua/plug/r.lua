vim.g.rout_follow_colorscheme = true

local M = {
  specs = {
    'R-nvim/R.nvim',
    'R-nvim/cmp-r',
  },
  ft = { 'r', 'rmd', 'quarto' },

  ---@type RConfigUserOpts
  opts = {
    R_args = { '--quiet', '--no-save' },
    pdfviewer = '',
    user_maps_only = true,
  },
}

M.config = function()
  require('r').setup(M.opts)
  require('cmp_r').setup({})
  require('which-key').add({
    { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
    { '<localleader>R', '<Plug>RStart', ft = M.filetypes },
  })
end

return M
