local M = {}

--- Load all modules under a given directory.
---@param directory string
---@param opts? { recursive?: boolean }
---@return table<string, any>
M.module = function(directory, opts)
  local files = vim.fn.globpath(
    directory,
    table.concat({
      directory .. ((opts and opts.recursive) and "/**" or "/*") .. "*.lua",
      directory .. ((opts and opts.recursive) and "/**" or "/*") .. "/init.lua",
    }, "\n"),
    false,
    true
  )

  local ret = {}
  for _, full in ipairs(files) do
    local resolved = vim.fn.resolve(vim.fn.fnamemodify(full, ":p"))
    local mod = require("util.modname")(resolved)

    if mod and mod ~= "" then
      local ok, required = pcall(require, mod)
      if ok then
        ret[mod] = required
      end
    end
  end

  return ret
end

return M
