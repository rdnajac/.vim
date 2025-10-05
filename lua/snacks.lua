_G.svim = vim
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

---@class Snacks: snacks.plugins
local M = setmetatable({}, {
  __index = function(t, k)
    t[k] = require('snacks.' .. k)
    return rawget(t, k)
  end,
})
_G.Snacks = M

---@class snacks.config: snacks.Config
M.config = setmetatable({ styles = {} }, {
  __index = function(t, k)
    rawset(t, k, {})
    return t[k]
  end,
})

-- Load the _config module
local config_module = require('_config')

-- Set the config reference for _config module to use
config_module.set_config(M.config)

-- Attach _config module functions to M.config
M.config.merge = config_module.merge
M.config.example = config_module.example
M.config.get = config_module.get
M.config.style = config_module.style

-- Define default options for snacks
---@type snacks.config
local default_opts = {
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

-- Set enabled flag for all options by default
for k in pairs(default_opts) do
  if k ~= 'styles' then
    default_opts[k].enabled = default_opts[k].enabled == nil or default_opts[k].enabled
  end
end

-- Merge default options into config using _config.merge
M.config = config_module.merge(M.config, default_opts)

-- Update the config reference in _config module after merge
config_module.set_config(M.config)

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
