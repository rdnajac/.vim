local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

local realpath = function(path)
  if nv.is_nonempty_string(path) then
    return vim.fs.normalize(vim.uv.fs_realpath(path) or path)
  end
end

--- @param buf number 
local bufpath = function(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

---@class LazyRoot
---@field paths string[]
---@field spec LazyRootSpec

---@alias LazyRootFn fun(buf: number): (string|string[])
---@alias LazyRootSpec string|string[]|LazyRootFn

--- second parameter passed to `vim.fs.root()`
--- aliases make this easier to read
---@alias RootPredicate fun(name: string, path: string): boolean
---@alias RootMarker string|string[]|RootPredicate|(string|string[]|RootPredicate)[]

---@type RootMarker
M.spec = { 'lsp', { '.git', 'lua' }, 'cwd' }
-- NOTE: 'lsp' and 'cwd' are special values handled in M.detectors

-- TODO: refactor so we try 'lsp', then patterns (including git), then 'fallback to 'cwd'
M.detectors = {
  cwd = function()
    -- return { M.realpath(vim.uv.cwd()) }
    return { vim.uv.cwd() }
  end,
  ---@param patterns string[]|string
  pattern = function(buf, patterns)
    patterns = type(patterns) == 'string' and { patterns } or patterns
    local path = bufpath(buf) or vim.uv.cwd()
    local pattern = vim.fs.find(function(name)
      for _, p in ipairs(patterns) do
        if name == p then
          return true
        end
        if p:sub(1, 1) == '*' and name:find(vim.pesc(p:sub(2)) .. '$') then
          return true
        end
      end
      return false
    end, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
  end,
  lsp = function(buf)
    local bufpath = bufpath(buf)
    if not bufpath then
      return {}
    end
    local roots = {} ---@type string[]
    local clients = vim.lsp.get_clients({ bufnr = buf })
    clients = vim.tbl_filter(function(client)
      return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name)
    end, clients) --[[@as vim.lsp.Client[] ]]
    for _, client in pairs(clients) do
      local workspace = client.config.workspace_folders
      for _, ws in pairs(workspace or {}) do
        roots[#roots + 1] = vim.uri_to_fname(ws.uri)
      end
      if client.root_dir then
        roots[#roots + 1] = client.root_dir
      end
    end
    return vim.tbl_filter(function(path)
      path = vim.fs.normalize(path)
      return path and bufpath:find(path, 1, true) == 1
    end, roots)
  end,
}

---@param spec LazyRootSpec
---@return LazyRootFn
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == 'function' then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

---@param opts? { buf?: number, spec?: LazyRootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == 'table' and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  -- TODO: handle lsp and cwd outside of the spec
  -- so they always prioritized or fell back on respectively

  local ret = {} ---@type LazyRoot[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == 'table' and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

function M.info()
  local spec = type(vim.g.root_spec) == 'table' and vim.g.root_spec or M.spec

  local roots = M.detect({ all = true })
  local lines = {} ---@type string[]
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      lines[#lines + 1] = ('- [%s] `%s` **(%s)**'):format(
        first and 'x' or ' ',
        path,
        type(root.spec) == 'table' and table.concat(root.spec, ', ') or root.spec
      )
      first = false
    end
  end
  lines[#lines + 1] = '```lua'
  lines[#lines + 1] = 'vim.g.root_spec = ' .. vim.inspect(spec)
  lines[#lines + 1] = '```'
  Snacks.notify(lines, { title = 'Detected Roots' })
  return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

---@type table<number, string>
M.cache = {}

function M.setup()
  vim.api.nvim_create_user_command('GetRoot', function()
    Snacks.notify(M.info())
  end, { desc = 'LazyVim roots for the current buffer' })

  -- FIX: doesn't properly clear cache in neo-tree `set_root` (which should happen presumably on `DirChanged`),
  -- probably because the event is triggered in the neo-tree buffer, therefore add `BufEnter`
  -- Maybe this is too frequent on `BufEnter` and something else should be done instead??
  vim.api.nvim_create_autocmd({ 'LspAttach', 'BufWritePost', 'DirChanged', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('lazyvim_root_cache', { clear = true }),
    callback = function(event)
      M.cache[event.buf] = nil
    end,
  })
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false, buf = buf })
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end
  return ret
end

return M
