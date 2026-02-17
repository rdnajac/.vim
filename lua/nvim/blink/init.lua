--- `https://cmp.saghen.dev/`
---@module "blink.cmp"
---@type table<string, blink.cmp.SourceProviderConfig>
local providers = {
  buffer = {
    -- opts = {
    --   get_bufnrs = function()
    --     return vim.tbl_filter(function(bufnr)
    --       return vim.bo[bufnr].buftype == ''
    --     end, vim.api.nvim_list_bufs())
    --   end,
    -- },
  },
  lsp = {
    score_offset = -1,
    transform_items = function(_, items)
      local kind = require('blink.cmp.types').CompletionItemKind
      local exclude = vim.tbl_map(function(k) return kind[k] end, {
        'Snippet',
        -- 'Keyword'
      })
      return vim.tbl_filter(
        function(item) return not vim.tbl_contains(exclude, item.kind) end,
        items
      )
    end,
  },
  path = {
    score_offset = 100,
    opts = {
      get_cwd = function(_) return vim.fn.getcwd() end,
      show_hidden_files_by_default = true,
    },
  },
  snippets = {
    score_offset = 99,
    opts = { friendly_snippets = false },
    -- https://cmp.saghen.dev/recipes.html#hide-snippets-after-trigger-character
    -- FIXME: last line of a comment isn't a ts comment
    -- TODO: no snippets in middle of word
    should_show_items = function(ctx)
      if nv.is_comment() then
        return false
      else
        return ctx.trigger.initial_kind ~= 'trigger_character'
      end
    end,
  },
}

---@type blink.cmp.SourceConfigPartial
local sources = {
  ---@return blink.cmp.SourceList[]
  default = vim.tbl_keys(providers),
  per_filetype = {
    -- sql = i{ 'dadbod' }, -- TODO: ,
    vim = { inherit_defaults = true, 'env' },
  },
}
-- add LazyDev provider if available
-- if pcall(require, 'lazydev.integrations.blink') then
if vim.uv.fs_stat(vim.g['plug#home'] .. '/lazydev.nvim') then
  providers.lazydev = {
    name = 'LazyDev',
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  }
  sources.per_filetype.lua = { inherit_defaults = true, 'lazydev' }
end

---@type table<string, blink.cmp.SourceProviderConfigPartial>
local extras = {
  ['bydlw98/blink-cmp-env'] = {
    env = {
      name = 'env',
      module = 'blink-cmp-env',
      score_offset = -5,
      opts = {
        item_kind = function() return require('blink.cmp.types').CompletionItemKind.Variable end,
        show_braces = false,
        show_documentation_window = true,
      },
    },
  },
}

sources.providers = vim.iter(extras):fold(
  providers,
  function(acc, _, config) return vim.tbl_extend('force', acc, config) end
)

local blink_spec = {
  'Saghen/blink.cmp',
  -- TODO: build on initial install
  -- TODO: show completion menu on <C-R> in insert mode
  build = 'BlinkCmp build',
  event = 'UIEnter',
  ---@type blink.cmp.Config
  opts = {
    cmdline = { enabled = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = false },
      ghost_text = { enabled = false },
      -- keyword = {},
      list = { selection = { preselect = true, auto_insert = true } },
      trigger = {
        show_on_keyword = true,
        show_on_accept_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { '"', '(', '{', '[' },
      },
      menu = require('nvim.blink.completion').menu,
    },
    -- fuzzy = { implementation = 'lua' },
    keymap = {
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        function() return package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() end,
        function() return vim.lsp.inline_completion.get() end,
        'fallback',
      },
    },
    signature = {
      -- enabled = false, -- default = is `true`
      -- window = { show_documentation = false },
      -- TODO: check this
    },
    sources = sources, -- configured above
  },
}

local get_providers = function(mode)
  mode = (mode or vim.api.nvim_get_mode().mode):sub(1, 1)
  local cmp_mode = ({ c = 'cmdline', t = 'terminal' })[mode] or 'default'
  local ok, lib = pcall(require, 'blink.cmp.sources.lib')
  if not ok or not lib then
    return {}
  end
  local enabled = vim.tbl_keys(lib.get_enabled_providers(cmp_mode))
  table.sort(enabled)
  return enabled
end

local status = function()
  return ' '
    .. vim
      .iter(ipairs(get_providers()))
      :map(function(_, provider) return nv.icons.blink[provider] end)
      :join(' / ')
end

-- cond = function() return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i' end, },

local after = function()
  ---  vim.keymap.set('i', '<Tab>', function()
  ---   if not vim.lsp.inline_completion.get() then
  ---     return '<Tab>'
  ---   end
  --- end, { expr = true, desc = 'Accept the current inline completion' })
  -- vim.schedule(autocmds)
  -- vim.lsp.enable('copilot')
  vim.lsp.inline_completion.enable()

  -- NOTE: In GUI and supporting terminals, `<C-i>` can be mapped separately from `<Tab>`
  -- ...except in tmux: `https://github.com/tmux/tmux/issues/2705`
  -- vim.keymap.set('n', '<C-i>', '<Tab>', { desc = 'restore <C-i>' })

  local toggle_inline_completion = Snacks.toggle.new({
    name = 'Inline Completion',
    get = function() return vim.lsp.inline_completion.is_enabled() end,
    set = function(state) vim.lsp.inline_completion.enable(state) end,
  })
  toggle_inline_completion:map('<leader>ai')

  -- FIXME:
  -- local aug = vim.api.nvim_create_augroup('HideInlineCompletion', {})
  -- vim.api.nvim_create_autocmd('User', {
  --   group = aug,
  --   pattern = 'BlinkCmpMenuOpen',
  --   callback = function() toggle_inline_completion:toggle() end,
  -- })
  -- vim.api.nvim_create_autocmd('User', {
  --   group = aug,
  --   pattern = 'BlinkCmpMenuClose',
  --   callback = function() toggle_inline_completion:toggle() end,
  -- })
end

return {
  specs = vim.list_extend({ blink_spec }, vim.tbl_keys(extras)),
  -- statusline component showing active completion sources
  status = status,
  after = after,
}
