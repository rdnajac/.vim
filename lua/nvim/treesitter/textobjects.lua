return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main', -- XXX: should be updated soon
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
    -- vim.keymap.set({ 'x', 'o' }, 'as', function()
    -- require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
    -- end)
    local function select_textobject(textobject)
      return require('nvim-treesitter-textobjects.select').select_textobject(
        textobject,
        'textobjects'
      )
    end
    return {
      mode = { 'x', 'o' },
      { 'af', function() select_textobject('@function.outer') end },
      { 'if', function() select_textobject('@function.inner') end },
      { 'ac', function() select_textobject('@class.outer') end },
      { 'ic', function() select_textobject('@class.inner') end },
    }
  end,
}
