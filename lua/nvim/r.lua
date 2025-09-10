vim.g.rout_follow_colorscheme = true

local M = {
  --- HACK: lowercase `r` to match the modname
  'R-nvim/r.nvim',
  ft = { 'r', 'rmd', 'quarto' },
  specs = {
    'Saghen/blink.compat',
    'R-nvim/cmp-r',
  },
  --- @type RConfigUserOpts
  opts = {
    R_args = { '--quiet', '--no-save' },
    pdfviewer = '',
    user_maps_only = true,
    quarto_chunk_hl = { highlight = false },
  },
}

vim.schedule(function()
  require('which-key').add({
    { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
    { '<localleader>R', '<Plug>RStart', ft = M.filetypes },
  })
end)

return M
