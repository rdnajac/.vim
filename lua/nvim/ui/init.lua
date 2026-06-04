vim.cmd([[
set cmdheight=0
set laststatus=3
set pumheight=10
set pumblend=0
set pumborder=rounded
set winborder=rounded
set stl=%{%v:lua.nv.ui.status()%}
set wbr=%{%v:lua.nv.ui.winbar()%}
]])

local ui_fts = { 'msg', 'pager' }
vim.treesitter.language.register('markdown', ui_fts)
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = ui_fts,
  callback = function(ev)
    vim.treesitter.start(0)
    vim.wo.conceallevel = 3
    vim.keymap.set({ 'n' }, 'gf', require('nvim.util').better_gf, { buf = ev.buf })
  end,
  desc = 'Apply markdown tree-sitter highlighting for message windows',
})

local ui2_opts = { msg = { targets = 'msg' } }

return {
  icons = require('nvim.ui.icons'),
  setup = function() require('vim._core.ui2').enable(ui2_opts) end,
  status = require('nvim.ui.status'),
  winbar = require('nvim.ui.winbar'),
}
