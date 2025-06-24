local M = {}

M.source = function(self)
  local cwd = self:cwd()
  local alt = self.source == 'files' and 'grep' or 'files'
  self:close()
  Snacks.picker(alt, { cwd = cwd })
end

return M
