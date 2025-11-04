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
      hook = {
        on_filetype = function()
	  -- vim.cmd([[
	  --   setl fdm=expr foldexpr=v:lua.vim.treesitter.foldexpr()
	  -- ]])
        end,
        -- after_config = function() vim.notify("R.nvim is configured") end,
        -- after_R_start = function() vim.notify("R was launched") end,
        -- after_ob_open = function() vim.notify("Object Browser") end,
      },
    }
    require('r').setup(opts)
  end,
}
