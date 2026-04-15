local M = {}

M.parsers = require('nvim.treesitter.parsers')

local aug = vim.api.nvim_create_augroup('nv.treesitter', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = M.parsers.to_autostart(),
  group = aug,
  callback = function(ev) vim.treesitter.start(ev.buf) end,
  desc = 'Automatically start tree-sitter',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'r', 'rmd', 'quarto' },
  group = aug,
  command = [[ setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr() ]],
  desc = 'Use treesitter folding for select filetypes',
})

M.specs = {
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
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    enabled = false,
    opts = {
      move = { set_jumps = true },
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      },
    },
    keys = function()
      -- You can also use captures from other query groups like `locals.scm`
      -- vim.keymap.set({ 'x', 'o' }, 'as',
      -- function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end)
      local function select(obj)
        return require('nvim-treesitter-textobjects.select').select(obj, 'textobjects')
      end
      return {
        { { 'x', 'o' }, 'af', function() select('@function.outer') end },
        { { 'x', 'o' }, 'if', function() select('@function.inner') end },
        { { 'x', 'o' }, 'ac', function() select('@class.outer') end },
        { { 'x', 'o' }, 'ic', function() select('@class.inner') end },
      }
    end,
  },
}

-- lazy load treesitter plugins when not opening a file
if vim.fn.argc(-1) == 0 then
  Plug(M.specs)
else
  vim.schedule(function() Plug(M.specs) end)
end

return M
