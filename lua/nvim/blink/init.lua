local M = { 'Saghen/blink.cmp' }

-- TODO: use the new build ex command `:...`
-- M.build = 'cargo build --release'
M.lazy = false
--- FIXME: lazy = true breaks loading cmp-r
M.specs = { 'Saghen/blink.compat' }

local border = vim.o.winborder == '' and 'single' or nil
local icons = require('nvim.icons')

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  -- cmdline = { enabled = false },
  completion = {
    documentation = {
      auto_show = false,
      window = { border = border },
    },
    trigger = {
      show_on_keyword = true,
      show_on_accept_on_trigger_character = true,
      show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
    },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      auto_show = true,
      -- auto_show_delay_ms = 1000,
      --- @param ctx blink.cmp.Context
      --- @param items blink.cmp.CompletionItem[]
      -- auto_show_delay_ms = function(ctx, items)
      --   if ctx.trigger.initial_character == '.'
      --   then
      --     return 0
      --   end
      --   return 1000
      -- end,
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
  },
  fuzzy = { implementation = 'lua' },
  keymap = require('nvim.blink.keymap'),
  signature = {
    enabled = true,
    window = { border = border, show_documentation = false },
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
  -- some config can be changed after setup
  local conf = require('blink.cmp.config')

  conf.cmdline.enabled = false

  local completion = conf.completion
  completion.accept.auto_brackets.enabled = true
  completion.ghost_text.enabled = false
  -- Snacks.util.set_hl({ ghost_text = 'BlinkCmpGhostText',  }, { link = 'MoreMsg', default = true })

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
