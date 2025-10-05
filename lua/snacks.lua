---@class Snacks: snacks.plugins
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('snacks.' .. k)
    return rawget(t, k)
  end,
})

_G.svim = vim
_G.Snacks = M
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function(...)
  Snacks.debug.backtrace(...)
end
_G.p = function(...)
  Snacks.debug.profile(...)
end
--- @diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

local config = { styles = {} }

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

---@type snacks.config
local opts = {
  bigfile = {},
  dashboard = require('nvim.snacks.dashboard'),
  explorer = { replace_netrw = false }, -- using `oil` instead
    -- stylua: ignore
  image = { formats = { 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'heic', 'avif', 'mp4', 'mov', 'avi', 'mkv', 'webm', 'pdf' }, },
  indent = { indent = { only_current = true, only_scope = true } },
  input = {},
  notifier = require('nvim.snacks.notifier'),
  picker = require('nvim.snacks.picker'),
  quickfile = {},
  scratch = { template = 'local x = \n\nprint(x)' },
  terminal = { start_insert = false, auto_insert = true, auto_close = true },
  scope = {},
  scroll = {},
  -- statuscolumn = { enabled = false },
  styles = {
    dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
    lazygit = { height = 0, width = 0 },
    terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
    notification_history = {
      wo = { number = false, winhighlight = 'WinBar:Chromatophore' },
      position = 'bottom',
      width = 100,
      height = 0.4,
    },
  },
  words = {},
}

for k in pairs(opts) do
  opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
end

config = vim.tbl_deep_extend('force', config, opts)

local events = {
  BufReadPre = { 'bigfile', 'image' },
  BufReadPost = { 'quickfile', 'indent' },
  BufEnter = { 'explorer' },
  LspAttach = { 'words' },
  VimEnter = { 'dashboard' },
  UIEnter = { 'scroll', 'input', 'scope', 'picker' },
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
      else
        error('No setup or enable function found for snack: ' .. snack)
      end
    else
      print('disabled: ' .. snack)
    end
  end
end

local group = vim.api.nvim_create_augroup('snacks', { clear = true })
vim.api.nvim_create_autocmd(vim.tbl_keys(events), {
  group = group,
  once = true,
  nested = true,
  callback = function(ev)
    load(ev.event, ev)
  end,
})

vim.api.nvim_create_autocmd('BufReadCmd', {
  once = true,
  pattern = '*.' .. table.concat(M.config.image.formats, ',*.'),
  group = group,
  callback = function(e)
    require('snacks.image').setup(e)
  end,
})

-- vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

vim.notify = function(msg, level, o)
  vim.notify = Snacks.notifier.notify
  return Snacks.notifier.notify(msg, level, o)
end

M.did_setup = true
M.did_setup_after_vim_enter = false

-- print('snack attack!')
return M
