local gen = require('mini.clue').gen_clues
local clues = {}
-- TODO:
local triggers = {
  { mode = 'n', keys = 'cd' },
}
for clue, trigger_list in pairs({
  builtin_completion = {
    { mode = 'i', keys = '<C-x>' },
  },
  g = {
    { mode = { 'n', 'x' }, keys = 'g' },
  },
  marks = {
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
  },
  registers = {
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
  },
  square_brackets = {
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },
  windows = {
    { mode = 'n', keys = '<C-w>' },
  },
  z = {
    { mode = { 'n', 'x' }, keys = 'z' },
  },
}) do
  table.insert(clues, gen[clue]())
  vim.list_extend(triggers, trigger_list)
end

return {
  clues = clues,
  triggers = triggers,
  -- TODO:
  -- { mode = { 'n', 'x' }, keys = '<Leader>' },
  window = {
    -- config = {},
    -- delay = 1000,
    scroll_down = '<C-j>',
    scroll_up = '<C-k>',
  },
}
