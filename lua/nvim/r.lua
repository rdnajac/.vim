Plug({ 'R-nvim/R.nvim' })

---@type RConfigUserOpts
local opts = {
  R_args = { '--quiet', '--no-save' },
  -- user_maps_only = true,
  -- quarto_chunk_hl = { highlight = false },
  Rout_more_colors = true,
  hook = {
    on_filetype = function()
      vim.keymap.set('n', 'yu', function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- copy the <cword> to a new line below the current line
        vim.api.nvim_buf_set_lines(0, row, row, true, { vim.fn.expand('<cword>') })
        -- move cursor to the new line
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        -- execute <Plug>RInsertLineOutput from normal mode
        vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
        -- delete the line with the word
        vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
        -- move cursor back to original position
        vim.api.nvim_win_set_cursor(0, { row, col })
      end, { desc = 'Debug/Print (R)', buf = 0 })
    end,
    after_R_start = function() vim.notify('R started!') end,
    after_ob_open = function() vim.notify('Object Browser opened!') end,
  },
}

require('r').setup(opts)
