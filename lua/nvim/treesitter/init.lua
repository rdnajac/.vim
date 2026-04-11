local M = {
  parsers = require('nvim.treesitter.parsers'),
  specs = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
      'nvim-treesitter/nvim-treesitter-context',
      -- enabled = false,
      toggles = {
        ['<leader>ux'] = {
          name = 'Treesitter Context',
          get = function() return require('treesitter-context').enabled() end,
          set = function() require('treesitter-context').toggle() end,
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
  },
}

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

-- FIXME: invalid key: 21
-- too many args
M.install_parsers = function() vim.cmd.TSInstall(M.parsers.to_install()) end

M.status = function()
  local ret = {}
  local highlighter = require('vim.treesitter.highlighter')
  local hl = highlighter.active[vim.api.nvim_get_current_buf()]
  ---@diagnostic disable-next-line: invisible
  local queries = hl and hl._queries
  if type(queries) == 'table' then
    ret = vim.tbl_map(function(query)
      if query == vim.bo.filetype then
        return ' '
      end
      return require('nvim.ui.icons').filetype[query]
    end, vim.tbl_keys(queries))
  end
  return table.concat(ret, ' ')
end

return M
