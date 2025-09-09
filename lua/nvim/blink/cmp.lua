local M = { 'Saghen/blink.cmp' }
-- M.build = 'cargo build --release'

M.specs = {
  'Saghen/blink.compat',
  'bydlw98/blink-cmp-env',
  'fang2hou/blink-copilot',
  'mgalliou/blink-cmp-tmux',
  'R-nvim/cmp-r',
}

M.event = 'InsertEnter'

local icons = require('nvim.icons')

---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  fuzzy = { implementation = 'lua' },
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = false } },
    documentation = {
      auto_show = true,
      window = { vim.o.winborder == '' and 'single' or nil },
    },
    list = { selection = { preselect = true, auto_insert = true } },
    ghost_text = { enabled = true },
    menu = {
      auto_show = false,
      border = vim.o.winborder == '' and 'single' or nil,
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
  signature = { enabled = true, window = { border = 'single' } },
  keymap = {
    -- default
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'cancel', 'fallback' },
    ['<C-y>'] = { 'select_and_accept', 'fallback' },
    -- moving up and down
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Left>'] = { 'select_prev', 'fallback' },
    ['<C-k'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Right>'] = { 'select_next', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
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

return M
