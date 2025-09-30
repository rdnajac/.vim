print('snack attack!')
---@class Snacks: snacks.plugins
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('snacks.' .. k)
    return rawget(t, k)
  end,
})

_G.Snacks = M
_G.svim = vim
vim.print(vim.inspect(vim.tbl_keys(Snacks.picker)))

--- Config Start [[
---@class snacks.Config.base
---@field example? string
---@field config? fun(opts: table, defaults: table)

---@class snacks.Config: snacks.plugins.Config
---@field styles? table<string, snacks.win.Config>
---@field image? snacks.image.Config|{}
local config = {
  image = {
  -- stylua: ignore
    formats = { 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'heic', 'avif', 'mp4', 'mov', 'avi', 'mkv', 'webm', 'pdf' },
  },
}
config.styles = {}

---@class snacks.config: snacks.Config
M.config = setmetatable({}, {
  __index = function(_, k)
    config[k] = config[k] or {}
    return config[k]
  end,
  __newindex = function(_, k, v)
    config[k] = v
  end,
})

M.config.merge = require('_config').merge
M.config.example = require('_config').example
-- M.config.get = require('_config').get
-- M.config.style = require('_config').style

---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
function M.config.get(snack, defaults, ...)
  local merge, todo = {}, { defaults, config[snack] or {}, ... }
  for i = 1, select('#', ...) + 2 do
    local v = todo[i] --[[@as snacks.Config.base]]
    if type(v) == 'table' then
      if v.example then
        table.insert(merge, vim.deepcopy(M.config.example(snack, v.example)))
        v.example = nil
      end
      table.insert(merge, vim.deepcopy(v))
    end
  end
  local ret = M.config.merge(unpack(merge))
  if type(ret.config) == 'function' then
    ret.config(ret, defaults)
  end
  return ret
end

--- Register a new window style config.
---@param name string
---@param defaults snacks.win.Config|{}
---@return string
function M.config.style(name, defaults)
  config.styles[name] =
    vim.tbl_deep_extend('force', vim.deepcopy(defaults), config.styles[name] or {})
  return name
end

-- Config End ]]

-- M.did_setup = false
-- M.did_setup_after_vim_enter = false

---@param opts snacks.Config?
-- function M.setup(opts)
-- if M.did_setup then
-- return vim.notify( 'snacks.nvim is already setup', vim.log.levels.ERROR, { title = 'snacks.nvim' })
-- end
-- M.did_setup = true

-- enable all by default when config is passed
-- opts = opts or {}
opts = require('nvim.snacks').opts
-- TODO: move opts
for k in pairs(opts) do
  opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
end
config = vim.tbl_deep_extend('force', config, opts or {})

local events = {
  BufReadPre = { 'bigfile', 'image' },
  BufReadPost = { 'quickfile', 'indent' },
  BufEnter = { 'explorer' },
  LspAttach = { 'words' },
  UIEnter = { 'dashboard', 'scroll', 'input', 'scope', 'picker' },
}

---@param event string
---@param ev? vim.api.keyset.create_autocmd.callback_args
local function load(event, ev)
  local todo = events[event] or {}
  events[event] = nil
  for _, snack in ipairs(todo) do
    if M.config[snack] and M.config[snack].enabled then
      if M[snack].setup then
        M[snack].setup(ev)
      elseif M[snack].enable then
        M[snack].enable()
      end
    end
  end
end

-- if vim.v.vim_did_enter == 1 then
--   M.did_setup_after_vim_enter = true
--   load('UIEnter')
-- end

local group = vim.api.nvim_create_augroup('snacks', { clear = true })
vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
  group = group,
  once = true,
  nested = true,
  callback = function(ev)
    load(ev.event, ev)
  end,
})

if M.config.image.enabled and #M.config.image.formats > 0 then
  vim.api.nvim_create_autocmd('BufReadCmd', {
    once = true,
    pattern = '*.' .. table.concat(M.config.image.formats, ',*.'),
    group = group,
    callback = function(e)
      require('snacks.image').setup(e)
    end,
  })
end

if M.config.statuscolumn.enabled then
  vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
end

if M.config.notifier.enabled then
  vim.notify = function(msg, level, o)
    vim.notify = Snacks.notifier.notify
    return Snacks.notifier.notify(msg, level, o)
  end
end
-- end

return M
