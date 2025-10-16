-- these require nvim nightly
vim.o.pumblend = 0
vim.o.pumborder = 'rounded'
vim.o.pumheight = 10

-- these must be set before extui is enabled
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
-- require('vim._extui').enable({})

-- run all `setup` functions in `nvim/config/*.lua` after startup
vim.schedule(function()
  _G.nv = _G.nv or require('nvim.util')
  nv.config = vim.iter(nv.submodules('config')):fold({}, function(acc, submod)
    local mod = require(submod)
    if type(mod.setup) == 'function' then
      mod.setup()
    end
    acc[submod:match('[^/]+$')] = mod
    return acc
  end)
end)

Snacks.picker.scriptnames = function()
  require('nvim.snacks.picker.scriptnames')
end

-- TODO: move to util module
local print_debug = function()
  local ft = vim.bo.filetype
  local word = vim.fn.expand('<cword>')
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local templates = {
    -- lua = string.format("print('%s = ' .. vim.inspect(%s))", word, word),
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
  }
  local print_line = templates[ft]
  if not print_line then
    return
  end
  vim.api.nvim_buf_set_lines(0, row, row, true, { print_line })
end

vim.keymap.set('n', 'yu', print_debug, { desc = 'Debug <cword>' })
