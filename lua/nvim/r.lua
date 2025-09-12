vim.g.rout_follow_colorscheme = true

local M = {
  --- HACK: lowercase `r` to match the modname
  'R-nvim/r.nvim',
  -- ft = { 'r', 'rmd', 'quarto' },
  specs = {
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

function M.root()
  return vim.fs.root(0, {'.here.', '.Rprofile'})
end

local aug = vim.api.nvim_create_augroup('r.nvim', { clear = true }),
vim.api.nvim_create_autocmd({'BufEnter'}, {
  pattern = { '*.r', '*.rmd', '*.quarto' },
  group = aug,
  callback = function()
    vim.cmd.lcd(M.root())
    vim.cmd.pwd()
  end,
  desc = '',
})

return M
