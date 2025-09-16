vim.g.rout_follow_colorscheme = true

local M = {
  --- HACK: lowercase `r` to match the modname
  'R-nvim/r.nvim',
  -- ft = { 'r', 'rmd', 'quarto' },
  specs = {
    'R-nvim/cmp-r',
  },
}

M.debug_word = function()
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- 3. Insert a new line below current line with just the word
  vim.api.nvim_buf_set_lines(0, row, row, true, { word })
  -- 4. Move cursor to the new line
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  -- 5. Feed keys to trigger your <Plug> mapping
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Plug>RInsertLineOutput', true, false, true),
    'n',
    false
  )
  -- 6. Delete the temporary line (the one we just inserted)
  vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
  -- 7. Move cursor back to original line
  vim.api.nvim_win_set_cursor(0, { row, col })
end


--- @module "r"
--- @type RConfigUserOpts
M.opts = {
  R_args = { '--quiet', '--no-save' },
  pdfviewer = '',
  user_maps_only = true,
  quarto_chunk_hl = { highlight = false },
  register_treesitter = true, -- DIY
  hook = {
    on_filetype = function()
      -- info('R.nvim on_filetype hook')
      vim.treesitter.start(0, 'markdown')
      vim.keymap.set('n', '<localleader><CR>', M.debug_word, { buffer = true })
    end,
  },
}

M.after = function()
  -- vim.treesitter.language.register('markdown', { 'quarto', 'rmd' })
  -- require('nvim.treesitter').autostart({ 'quarto', 'rmarkdown' })
  require('which-key').add({
    { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },
    { '<localleader>R', '<Plug>RStart', ft = M.filetypes },
  })
end

function M.root()
  return vim.fs.root(0, { '.here.', '.Rprofile' })
end

local aug =
  vim.api.nvim_create_augroup('r.nvim', { clear = true }),
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = { '*.r', '*.rmd', '*.quarto' },
    group = aug,
    callback = function()
      vim.cmd.lcd(M.root())
      vim.cmd.pwd()
    end,
    desc = '',
  })

return M
