Plug({
  { 'nvim-treesitter/nvim-treesitter' },
  require('nvim.treesitter.context'),
  -- require('nvim.treesitter.textobjects')
})

nv.on(
  'FileType',
  vim
    .iter(nv.treesitter.parsers)
    :filter(function(lang)
      return not vim.tbl_contains({
        'latex', -- breaks vimtex
        'lua', -- started by default
      }, lang)
    end)
    :totable(),
  function(ev) vim.treesitter.start(ev.buf) end
)

-- also enable legacy syntax for Lua and Vimscript,
-- since some plugins still rely on it
nv.on('FileType', { 'lua', 'vim' }, function(ev) vim.bo[ev.buf].syntax = 'ON' end)

-- incremental-selection (C-Space to init/expand, C-BS to shrink)
vim.cmd([[nmap <C-Space> van | xmap <C-Space> an | xmap <C-BS> in]])
