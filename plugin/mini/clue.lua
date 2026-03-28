local miniclue = require('mini.clue')

local clues = { miniclue.gen_clues.builtin_completion() }
local triggers = { { mode = 'i', keys = '<C-x>' } }

if not package.loaded['which-key'] then
  for clue, trigger_list in pairs({
    g = { { mode = { 'n', 'x' }, keys = 'g' } },
    marks = {
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '~' },
    },
    registers = {
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },
    },
    square_brackets = {
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
    },
    windows = { { mode = 'n', keys = '<C-w>' } },
    z = { { mode = { 'n', 'x' }, keys = 'z' } },
  }) do
    table.insert(clues, miniclue.gen_clues[clue]())
    vim.list_extend(triggers, trigger_list)
  end
end

miniclue.setup({
  clues = clues,
  triggers = triggers,
  window = {
    -- config = {},
    delay = 420,
    scroll_down = '<C-j>',
    scroll_up = '<C-k>',
  },
})
