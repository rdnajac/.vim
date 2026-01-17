
M.config = function()
  {R_args = { '--quiet', '--no-save' },
    -- user_maps_only = true,
    -- quarto_chunk_hl = { highlight = false },
    Rout_more_colors = true,
    hook = {
      -- after_R_start = function() vim.notify('R was launched') end,
      -- after_ob_open = function() vim.notify('Object Browser') end,
    },
  }
  require('r').setup()
end

