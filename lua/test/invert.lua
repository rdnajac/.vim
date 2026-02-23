-- nv.tbl_add_inverse_lookup
-- vim.tbl_add_reverse_lookup(M.kinds)
-- shared method is deprecated because it is not type safe
-- https://github.com/neovim/neovim/pull/24564

vim.print(vim.iter({ a = 'x1', b = 'x2', c = 'x3', d = 'x4' }):fold({}, function(t, k, v)
  t[v] = k
  return t
end))

-- local inv = {}
-- for k, v in pairs(t) do
--   inv[v] = k
-- end

local tbl_add_inverse_lookup = function(t)
  for _, k in ipairs(vim.tbl_keys(t)) do
    t[t[k]] = k
  end
  return t
end

-- BUG: don't do this
for k, v in pairs(t) do
  t[v] = k
end
