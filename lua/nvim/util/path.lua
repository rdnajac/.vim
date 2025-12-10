local M = {}

local function normalize(path)
  return vim.fs.normalize(path, { _fast = true })
end

local function relative(p, b)
  local p_parts = vim.split(p:gsub('/+$', ''), '/', { plain = true })
  local b_parts = vim.split(b:gsub('/+$', ''), '/', { plain = true })

  local i = 0
  while i < #p_parts and i < #b_parts and p_parts[i + 1] == b_parts[i + 1] do
    i = i + 1
  end

  local rel = {}
  for _ = i + 1, #b_parts do
    table.insert(rel, '..')
  end
  for j = i + 1, #p_parts do
    table.insert(rel, p_parts[j])
  end

  return #rel == 0 and '.' or table.concat(rel, '/')
end

--- Get relative path parts for display
--- @param buf number|nil Buffer number (defaults to current buffer)
--- @return string[] Array with [prefix, suffix]
function M.relative_parts(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  if file == '' or not vim.uv.fs_stat(file) then
    return { '', '' }
  end

  file = normalize(file)
  local cwd = normalize(vim.fn.getcwd(0, 0))
  local root = normalize(Snacks.git.get_root(file))

  if nv.fn.is_nonempty_string(root) then
    if cwd == root or vim.startswith(cwd, root .. '/') then
      local name = vim.fn.fnamemodify(root, ':t')
      local rel = relative(cwd, root)
      return { name .. (rel == '.' and '' or '/' .. rel), relative(file, cwd) }
    end
  end

  return { vim.fn.fnamemodify(cwd, ':~'), relative(file, cwd) }
end

return M
