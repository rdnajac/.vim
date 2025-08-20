local M = { 'Saghen/blink.cmp' }

M.build = 'cargo build --release'

M.dependencies = {
  'bydlw98/blink-cmp-env',
  'fang2hou/blink-copilot',
  'mgalliou/blink-cmp-tmux',
}

M.event = 'InsertEnter'

local kind = vim.lsp.protocol.SymbolKind
-- local kind = require('blink.cmp.types').CompletionItemKind


---@module "blink.cmp"
---@type blink.cmp.Config
M.opts = {
  fuzzy = { implementation = 'lua' },
  cmdline = { enabled = false },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    -- documentation = { auto_show = true, window = { border = 'single' } },
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      -- auto_show = true,
      -- border = 'single',
      draw = {
        treesitter = { 'lsp' },
        columns = {

          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          -- { 'source_name' },
          -- { 'source_id' },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              return N.icons.kinds[ctx.kind] or ''
            end,
          },
        },
      },
    },
  },
  signature = { enabled = true, window = { border = 'single' } },
  keymap = {
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Left>'] = { 'select_prev', 'fallback' },
    ['<C-k'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<Right>'] = { 'select_next', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<Tab>'] = {
      function(cmp)
        local item = cmp.get_selected_item()
        local type = require('blink.cmp.types').CompletionItemKind

        if cmp.is_visible() and item then
          -- if item.kind == type.Snippet then
          if item.kind == type.Path then
            cmp.accept()
            vim.defer_fn(function()
              cmp.show({ providers = { 'path' } })
            end, 1)
            return true
          else
            return cmp.accept()
          end
        end
      end,
      'fallback',
    },
  },
  sources = require('plug.blink.sources'),
}

M.config = function()
  require('blink.cmp').setup(M.opts)

  vim.keymap.set('i', '$', function()
    require('blink.cmp').show({ providers = { 'env' } })
    return '$'
  end, { expr = true, replace_keycodes = false })
end

--- Blink statusline component
M.component = function()
  if not package.loaded['blink.cmp.sources.lib'] then
    return ''
  end

  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    return ''
  end

  local enabled = sources.get_enabled_providers('default')
  local source_icons = N.icons.src
  local out = {}

  for name in pairs(sources.get_all_providers()) do
    if enabled[name] then
      table.insert(out, source_icons[name])
    end
  end

  return table.concat(out, ' ')
end

print(M.component())


return M
