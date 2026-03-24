if package.loaded['which-key'] then
  return
end

local miniclue = require('mini.clue')

local clues = {
  { mode = 'n', keys = '<Bslash><Bslash>', desc = '+Bookmarks' },
}

local triggers = {
  { mode = 'n', keys = 'cd' },
  -- { mode = 'n', keys = '\\', },
  { mode = 'n', keys = '<Bslash>' },
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
  windows = {
    { mode = 'n', keys = '<C-w>' },
  },
  z = {
    { mode = { 'n', 'x' }, keys = 'z' },
  },
}) do
  table.insert(clues, miniclue.gen_clues[clue]())
  vim.list_extend(triggers, trigger_list)
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
