vim.g.plug_home = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

local user_repo_regex = '^[%w._-]+/[%w._-]+$'

local function is_nonempty_string(x)
  return type(x) == 'string' and x ~= ''
end

local function gh(user_repo)
  if is_nonempty_string(user_repo) and user_repo:match(user_repo_regex) then
    return 'https://github.com/' .. user_repo .. '.git'
  end
  return user_repo
end

--- @param p string plugin (`user/repo`)
local function to_spec(p)
  return {
    src = gh(p),
    name = p:match('([^/]+)$'):gsub('%.nvim$', ''),
    version = p:match('treesitter') and 'main' or nil,
    data = p:match('treesitter') and nil or { needs_config = true },
  }
end

local M = {}

--- @return vim.pack.Spec
function M.plug(m)
  local mod = require('util').safe_require('nvim.' .. m)
  if not mod then
    return
  end

  local ret
  local spec = mod[1] and to_spec(mod[1]) or nil -- spec is a table
  if spec then
    ret = vim.tbl_map(gh, vim.list_extend({ spec }, mod.specs or {}))
  else
    ret = vim.tbl_map(to_spec, mod.specs or {})
  end
  return ret
end

function M.end_()
  -- called from vim.fn['plug#end']()
  -- no args, just check for the global plug list
  -- TODO: vim validate is list and is nonempty
  -- local specs = vim.g['plug#list']
  nv.specs = vim.tbl_map(function(p)
    -- convert certain plugins to plug specs with additional data
    return vim.endswith(p, '.nvim') and to_spec(p) or p
  end, vim.g['plug#list'])

  -- FIXME:
  vim.list_extend(nv.specs, M.plug('blink'))
  vim.list_extend(nv.specs, M.plug('treesitter'))

  local lsp_specs = M.plug('lsp')
  lsp_specs[1].data.needs_config = false
  vim.list_extend(nv.specs, lsp_specs)

  vim.pack.add(nv.specs, {
    confirm = vim.v.did_enter == 1, -- don't confirm during startup
    load = function(data)
      local spec = data.spec
      local plugin = spec.name
      -- FIXME: 
      local needs_config = spec.data and spec.data.needs_config == true or false
      local bang = vim.v.vim_did_enter == 0
      -- bang if we have to config immediately
      -- local bang = needs_config or vim.v.vim_did_enter == 0

      vim.cmd.packadd({ plugin, bang = bang, magic = { file = false } })

      if needs_config then
        local ok, mod = pcall(require, 'nvim.' .. plugin:gsub('%.cmp$', ''))
        if vim.is_callable(mod.config) then
          mod.config()
        else
          local opts = (ok and mod and mod.opts) or {}
          require(spec.name).setup(opts)
        end
        nv.did_setup[#nv.did_setup + 1] = plugin
      end
    end,
  })
end

return setmetatable(M, {
  __call = function(_, plugin)
    return M.plug(plugin)
  end,
})
