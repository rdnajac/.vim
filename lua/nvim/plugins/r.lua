return {
  'R-nvim/R.nvim',
  ft = { 'r', 'rmd', 'quarto' },
  config = function()
    vim.g.rout_follow_colorscheme = true
    ---@module "r"
    ---@type RConfigUserOpts
    local opts = {
      R_args = { '--quiet', '--no-save' },
      -- pdfviewer = 'skim',
      user_maps_only = true,
      quarto_chunk_hl = { highlight = false },
    }
    require('r').setup(opts)
  end,
}
