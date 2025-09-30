vim.g.rout_follow_colorscheme = true
local debug_word = function()
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, true, { word })
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
  vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
  vim.api.nvim_win_set_cursor(0, { row, col })
end
local M = {
  'R-nvim/r.nvim', --- HACK: lowercase `r` to match the modname
  specs = { 'R-nvim/cmp-r' },
  --- @module "r"
  --- @type RConfigUserOpts
  opts = {
    R_args = { '--quiet', '--no-save' },
    pdfviewer = '',
    user_maps_only = true,
    quarto_chunk_hl = { highlight = false },
  },
  keys = {
    ft = { 'r', 'rmd', 'quarto' },
    icon = { icon = ' ', color = 'blue' },
    { '<localleader>r', group = 'R' },
    { '<localleader>\\', '<Plug>RStart' },
    { '<localleader><CR>', debug_word },
  },
}

-- TODO: call here::root() on BufEnter for r, rmd, quarto
-- or use this if its working correctly
-- TODO: resolve this with `nv.lsp.root`
function M.root(buf)
  return vim.fs.root(buf or 0, { '.here.', { '.Rprofile', '.Rproj', 'DESCRIPTION' }, '.git' })
end

return M
