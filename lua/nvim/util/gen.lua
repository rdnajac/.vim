local nv = _G.nv or require('nvim')

local M = setmetatable({}, {
  __call = function(M, ...)
    return M.gen(...)
  end,
})

function M.gen()
  vim
    .iter(nv.submodules())
    :map(function(submod)
      -- local fname = vim.fs.abspath(submod)
      local fname = vim.fn.fnamemodify(submod, ':t')
      return ([[nv.%s = require('nvim.util.%s')]]):format(fname, fname)
    end)
    :each(print)
end

return M
