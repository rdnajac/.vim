local M = {}
M.__index = function(self, key)
  local val = rawget(M, key)
  if type(val) == 'function' then
    return function(_, ...)
      nv.did = nv.did or {}
      nv.did[key] = nv.did[key] or {}

      local ok, result = pcall(val, self, ...)
      if ok then
        table.insert(nv.did[key], {
          plugin = self.name,
          success = ok,
        })
        return result
      end
    end
  else
    return M[key] -- fallback to normal delegation
  end
end

return M
