local parsers = require('nvim.treesitter.parsers')
local parsers_to_autostart = vim
  .iter(parsers)
  :filter(function(_, v) return v ~= false end)
  :fold({}, function(acc, k, v)
    acc[#acc + 1] = k
    if type(v) == 'table' then
      -- register language `k` the provided filetypes `v`
      vim.treesitter.language.register(k, v)
      -- extend the list by all filetypes
      vim.list.extend(acc, v)
    end
    return acc
  end)

require('vim._core.util').nvim_on('FileType', nil, {
  pattern = parsers_to_autostart,
  desc = 'Automatically start tree-sitter',
}, function(ev) vim.treesitter.start(ev.buf) end)

-- incremental-selection (C-Space to init/expand, C-BS to shrink)
vim.cmd([[nmap <C-Space> van | xmap <C-Space> an | xmap <C-BS> in]])

local specs = {
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- enabled = false,
    toggle = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() return require('treesitter-context').toggle() end,
      },
    },
  },
}

-- lazy load treesitter plugins when not opening a file
if vim.fn.argc(-1) == 0 then
  Plug(specs)
else
  vim.schedule(function() Plug(specs) end)
end
