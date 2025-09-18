
Plugin.__index = function(self, key)
  local val = rawget(Plugin, key)
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
    elseif val ~= nil then
      return val
    else
      return Plugin[key] -- fallback to normal delegation
    end
  end
end
