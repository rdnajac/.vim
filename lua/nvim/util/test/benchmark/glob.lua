local benchmark = require('test.benchmark')

benchmark.run({
  ["globpath stdpath/config + '/after/lsp'"] = function()
    return vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true)
  end,
  ["globpath stdpath/config + '/after/lsp/*'"] = function()
    return vim.fn.globpath(vim.fn.stdpath('config'), '/after/lsp/*', true, true)
  end,
  ['globpath literal ~/.config/nvim/after/lsp'] = function()
    return vim.fn.globpath('~/.config/nvim/after/lsp', '*', true, true)
  end,
})
