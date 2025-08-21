local M = { 'Saghen/blink.cmp' }

M.build = 'cargo build --release'

M.dependencies = {
  'bydlw98/blink-cmp-env',
  'fang2hou/blink-copilot',
  'mgalliou/blink-cmp-tmux',
}

M.event = 'InsertEnter'

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
  local ok, sources = pcall(require, 'blink.cmp.sources.lib')
  if not ok then
    return ''
  end

  local enabled = sources.get_enabled_providers('default')
  local source_icons = N.icons.src

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
