local benchmark = require('test.benchmark')

local dir = vim.fs.joinpath(vim.g.stdpath.config, 'lua', 'nvim', 'plugins')
local files = vim.fn.globpath(dir, '[^i]*.lua', false, true)
local base = vim.fs.joinpath(vim.g.stdpath.config, 'lua')

benchmark.run({
  match = function()
    for _, path in ipairs(files) do
      local name = path:match('lua/(.-)%.lua$')
    end
  end,
  sub = function()
    for _, path in ipairs(files) do
      local rel = path:sub(#base + 2, -5)
    end
  end,
  fnamemodify = function()
    for _, path in ipairs(files) do
      local name = vim.fn.fnamemodify(path, ':r:s?.*/lua/??')
    end
  end,
  relpath = function()
    for _, path in ipairs(files) do
      local rel = vim.fs.relpath(base, path)
      rel = rel:sub(1, -5)
    end
  end,
})
