local nv = _G.nv or require('nvim')
---@module "blink.cmp"
-- `https://cmp.saghen.dev/`
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

local extras = require('nvim.blink.extras')
sources.providers = vim.iter(extras):fold(
  providers,
  function(acc, _, config) return vim.tbl_extend('force', acc, config) end
)

local blink_spec = {
  'Saghen/blink.cmp',
  -- TODO: build on initial install
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
  local providers = vim.tbl_keys(require('blink.cmp.sources.lib').get_enabled_providers(cmp_mode))
  table.sort(providers)
  return providers
end

local status = function()
  local providers = get_providers()
  return vim
    .iter(ipairs(providers))
    :map(function(_, provider) return nv.icons.blink[provider] end)
    :join(' / ')
end

-- cond = function() return package.loaded['blink.cmp'] and vim.fn.mode():sub(1, 1) == 'i' end, },

return {
  specs = vim.list_extend({ blink_spec }, vim.tbl_keys(extras)),
  -- statusline component showing active completion sources
  status = status,
}
