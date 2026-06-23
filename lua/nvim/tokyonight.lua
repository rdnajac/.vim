local M = { 'folke/tokyonight.nvim' }

---@param groups tokyonight.Highlights
---@return string[] list of `vim.api.nvim_set_hl` calls for all groups
function M.lua_api(groups)
  return vim
    .iter(groups)
    :map(function(name, hl)
      hl = type(hl) == 'string' and { link = hl } or hl
      return ('vim.api.nvim_set_hl(0, %q, %s)'):format(
        name,
        vim.inspect(hl, { newline = '', indent = '' })
      )
    end)
    :totable()
end

function M.colorscheme(groups)
  vim.iter(groups):each(function(name, hl)
    hl = type(hl) == 'string' and { link = hl } or hl
    vim.api.nvim_set_hl(0, name, hl)
  end)
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

function M.vimscript(groups) return require('nvim.tokyonight.scheme').gen(groups) end

---@param colors ColorScheme
function M.terminal(colors)
  for i, color in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
    vim.g['terminal_color_' .. (i - 1)] = colors.terminal[color]
    vim.g['terminal_color_' .. (i + 7)] = colors.terminal[color .. '_bright']
  end
end

--- Simple string interpolation. Example template: "${name} is ${value}"
---
--- @param str string template string
--- @param table table key value pairs to replace in the string
function M.template(str, table)
  return (
    str:gsub(
      '($%b{})',
      function(w)
        return vim.tbl_get(table, unpack(vim.split(w:sub(3, -2), '.', { plain = true }))) or w
      end
    )
  )
end

---@param file string
function M.read(file)
  local fd = assert(io.open(file, 'r'))
  ---@type string
  local data = fd:read('*a')
  fd:close()
  return data
end

---@param file string
---@param contents string
function M.write(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = assert(io.open(file, 'w+'))
  fd:write(contents)
  fd:close()
end

M.cache = {}
function M.cache.file() return vim.fs.joinpath(vim.fn.stdpath('cache'), 'tokyonight.json') end
function M.cache.clear() vim.uv.fs_unlink(M.cache.file()) end
---@param data tokyonight.Cache
function M.cache.write(data) pcall(M.write, M.cache.file(), vim.json.encode(data)) end
function M.cache.read()
  ---@type boolean, tokyonight.Cache
  local ok, ret = pcall(
    function()
      return vim.json.decode(
        M.read(M.cache.file()),
        { luanil = {
          object = true,
          array = true,
        } }
      )
    end
  )
  return ok and ret or nil
end

return M
-- vim: fdl=0
