local M = {
  {
    ']]',
    function() Snacks.words.jump(vim.v.count1) end,
    mode = { 'n', 't' },
    desc = 'Next Reference',
  },
  {
    '[[',
    function() Snacks.words.jump(-vim.v.count1) end,
    mode = { 'n', 't' },
    desc = 'Prev Reference',
  },
}

return M
