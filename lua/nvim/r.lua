vim.g.rout_follow_colorscheme = true

local M = {
  'R-nvim/r.nvim', --- HACK: lowercase `r` to match the modname
   -- specs = { 'R-nvim/cmp-r' },
}

--- @module "r"
--- @type RConfigUserOpts
M.opts = {
  R_args = { '--quiet', '--no-save' },
  pdfviewer = '',
  user_maps_only = true,
  quarto_chunk_hl = { highlight = false },
  -- register_treesitter = true, -- DIY
  hook = {
    on_filetype = function()
      vim.keymap.set('n', '<localleader><CR>', M.debug_word, { buffer = true })
    end,
  },
}

-- TODO: 
-- > bc903b2 │ Run `vim.treesitter.start()` in all our filetypes (#437)

M.keys = {
  icon = { icon = ' ', color = 'blue' },
  { '<localleader>r', group = 'R' },
  { '<localleader>\\', '<Plug>RStart', ft = M.filetypes },
}

-- TODO: call here::root() on BufEnter for r, rmd, quarto
-- or use this if its working correctly
-- TODO: resolve this with `nv.lsp.root`
function M.root(buf)
  return vim.fs.root(buf or 0, { '.here.', { '.Rprofile', '.Rproj', 'DESCRIPTION' }, '.git' })
end

M.debug_word = function()
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, true, { word })
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
  vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
  vim.api.nvim_win_set_cursor(0, { row, col })
end

return M
