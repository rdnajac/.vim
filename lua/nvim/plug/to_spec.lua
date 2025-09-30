local M = {}

local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end
---
--- @param user_repo string plugin (`user/repo`)
--- @param data? any
--- @return string|vim.pack.Spec
M.to_spec = function(user_repo, data)
  local spec = {
    src = gh(user_repo),
    name = user_repo:match('([^/]+)$'):gsub('%.nvim$', ''),
    --- HACK: remove this when treesitter is on main
    version = user_repo:match('treesitter') and 'main' or nil,
    data = data,
  }
  return spec
end

return setmetatable(M, {
  __call = M.to_spec,
})
