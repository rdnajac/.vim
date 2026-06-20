local M = {}
local api, fn = vim.api, vim.fn
local core_util = require('vim._core.util')
local aug = api.nvim_create_augroup('nv.aug', {})

--- https://github.com/neovim/neovim/discussions/40320--- @param events vim.api.keyset.events|vim.api.keyset.events[]
--- @param events vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd
--- @param cb string|fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?
--- @return integer
M.on = function(events, opts, cb)
  vim.validate('opts', opts, 'table')
  vim.validate('cb', cb, { 'function', 'string' })
  if type(cb) == 'function' then
    opts.callback = cb
  else
    opts.command = cb
  end
  opts.group = opts.group or aug
  return vim.api.nvim_create_autocmd(events, opts)
end

---@param opts? vim.treesitter.get_node.Opts
M.is_comment = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  -- subtract one to account for 0-based row indexing in get_node
  opts.pos = opts.pos or { cursor[1] - 1, cursor[2] }
  local ok, node = pcall(vim.treesitter.get_node, opts)
  -- opts.pos is 0-indexed; synID expects 1-based row and col
  local type = (ok and node and node:type())
    or fn.synIDattr(fn.synID(cursor[1], cursor[2] + 1, 1), 'name')
  return not not type:match('comment')
end

--- handles truncated paths in the debug.traceback like `.../path/to/file:line:`
--- @param cfile? string defaults to `expand('<cfile>')`
--- @return string? Vim command to execute
M.goto_file = function(cfile)
  cfile = cfile or vim.fn.expand('<cfile>')
  if vim.startswith(cfile, '...') then
    -- HACK: the errors are probably from one of these two dirs
    for dir, pattern in pairs({ PACKDIR = '/core/opt/', VIMRUNTIME = '/nvim/runtime/' }) do
      local match = cfile:match('.*' .. pattern .. '(.*)')
      if match and match ~= '' then
        local file = vim.fs.joinpath(vim.env[dir], match)
        if file and vim.uv.fs_stat(file) then
          local cmd = ([[wincmd w| call edit#goto('%s')]]):format(cfile)
          return ('<Cmd>' .. cmd .. '<CR>')
        end
      end
    end
  end
  return '<C-w><C-f>'
end

function M.json_formatexpr()
  local indent = vim.bo.expandtab and (' '):rep(vim.o.shiftwidth) or '\t'
  local lines = api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum + vim.v.count - 1, true)
  local o = vim.json.decode(table.concat(lines, '\n'))
  local stringified = vim.json.encode(o, { indent = indent, sort_keys = true })
  lines = vim.split(stringified, '\n')
  api.nvim_buf_set_lines(0, vim.v.lnum - 1, vim.v.count, true, lines)
end
M.on('Filetype', {pattern ='json'}, 'setlocal formatexpr=v:lua.nv.json_formatexpr()')

M.submodule = function(_M, prefix)
  return setmetatable(_M or {}, {
    __index = function(t, k)
      local modname = prefix .. '.' .. k
      local ok, m = xpcall(require, debug.traceback, modname)
      if ok then
        -- Wrap the loaded module in a submodule proxy so its keys
        -- also lazy-load from `modname.<k>`
        if type(m) == 'table' then
          m = M.submodule(m, modname)
        end
        t[k] = m
        return m
      end
      -- Module doesn't exist — return a proxy anyway so deeper
      -- chains like `nvim.ui.foo` still work even if `nvim.ui`
      -- has no init file
      local proxy = M.submodule({}, modname)
      t[k] = proxy
      return proxy
    end,
  })
end

return M.submodule(M, 'nvim')
