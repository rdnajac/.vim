local M = {}

local function normalize(path)
  local home = vim.uv.os_homedir()
  if path:sub(1, 1) == '~' then
    path = home .. path:sub(2)
  end
  path = path:gsub('/+', '/')
  return path:sub(-1) == '/' and path:sub(1, -2) or path
end

local function get_buf_path()
  local name = vim.api.nvim_buf_get_name(0)
  local path = name:match('^oil://') and require('oil').get_current_dir() or vim.fn.expand('%:p')
  return normalize(path)
end

local function find_git_root()
  local path = get_buf_path()
  local git_dir = vim.fs.find('.git', { path = path, upward = true })[1]
  return git_dir and normalize(vim.fn.fnamemodify(git_dir, ':h')) or ''
end

local function split_path(path)
  return vim.split(path, '/', { plain = true })
end

local function relative_parts(path, base)
  if path == base then
    return {}
  end
  local p, b = split_path(path), split_path(base)
  local i = 1
  while p[i] and b[i] and p[i] == b[i] do
    i = i + 1
  end
  local parts = {}
  if i <= #b then
    for _ = i, #b do
      table.insert(parts, '..')
    end
  end
  for j = i, #p do
    table.insert(parts, p[j])
  end
  return parts
end

M.prefix = {
  function()
    local icon = '󱉭 '
    local root = find_git_root()
    if root == '' or vim.api.nvim_buf_get_name(0) == '' then
      return icon .. vim.fn.getcwd()
    end
    local cwd = normalize(vim.fn.getcwd())
    local rel = cwd:find(root, 1, true) == 1 and cwd:sub(#root + 2) or ''
    return icon .. vim.fs.basename(root) .. (rel ~= '' and '/' .. rel or '') .. '/'
  end,
  separator = { right = '🭛' },
}

M.suffix = {
  function()
    local path = get_buf_path()
    if path == '' then
      return ''
    end

    local root = find_git_root()
    local cwd = normalize(vim.fn.getcwd())

    if root == '' or not path:find(root, 1, true) then
      return vim.fn.fnamemodify(path, ':~') .. (path == cwd and '/' or '')
    end

    local rel_path = path:sub(#root + 2)
    local rel_cwd = cwd:sub(#root + 2)
    local parts = relative_parts(rel_path, rel_cwd)
    local out = table.concat(parts, '/')

    if out:sub(1, 3) == '../' then
      out = out:gsub('^%./+', ''):gsub('^%../+', '')
    end

    if #parts == 0 then
      out = './'
    end
    return out
  end,
  separator = { right = '🭛' },
  cond = function()
    return not vim.api.nvim_buf_get_name(0):match('^oil://')
  end,
}

M.modified = {
  function()
    local out = ''
    if vim.bo.modified or vim.bo.readonly then
      out = ' '
      if vim.bo.modified then
        out = out .. ''
      end
      if vim.bo.readonly then
        out = out .. ''
      end
    end
    return out
  end,
  separator = { right = '' },
}

return M
