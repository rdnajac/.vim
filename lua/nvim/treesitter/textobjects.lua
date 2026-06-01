return {
  'nvim-treesitter/nvim-treesitter-textobjects',
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
}
