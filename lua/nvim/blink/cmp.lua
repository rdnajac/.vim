local M = { 'Saghen/blink.cmp' }

-- M.build = 'cargo build --release'
-- M.event = 'InsertEnter'
M.specs = { 'Saghen/blink.compat' }

local border = vim.o.winborder == '' and 'single' or nil
local icons = require('nvim.icons')

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  fuzzy = { implementation = 'lua' },
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = false } },
    documentation = {
      auto_show = false,
      window = { border = border },
    },
    ghost_text = { enabled = true },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      auto_show = true,
      border = border,
      draw = {
        treesitter = { 'lsp' },
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
          -- { 'source_id' },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              return icons.kinds[ctx.kind] or ''
            end,
          },
        },
      },
    },
    trigger = {
      show_on_keyword = false,
    },
  },
  signature = {
    enabled = true,
    window = {
      border = border,
      show_documentation = false,
    },
  },
  keymap = {
    -- default if we had selected a preset
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'cancel', 'fallback' },
    ['<C-y>'] = { 'select_and_accept', 'fallback' },
  },
  sources = require('nvim.blink.sources'),
}

--- Blink statusline component
M.component = function()
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    return ''
  end

  local enabled = sources.get_enabled_providers('default')
  local source_icons = icons.src

  return vim
    .iter(sources.get_all_providers())
    :filter(function(name)
      return enabled[name] ~= nil
    end)
    :map(function(name)
      return source_icons[name] or ''
    end)
    :join('')
end

M.after = function()
  local url =
    'https://raw.githubusercontent.com/bydlw98/blink-cmp-env/refs/heads/main/lua/blink-cmp-env.lua'
  -- https://raw.githubusercontent.com/mgalliou/blink-cmp-tmux/refs/heads/main/lua/blink-cmp-tmux/init.lua
  local path =
    vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim', 'blink', 'sources', 'env.lua')
  if not vim.uv.fs_stat(path) then
    local wget = require('nvim.util.wget')
    wget(url, { outpath = path })
  end
end

return M
