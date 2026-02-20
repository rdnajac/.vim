---@type table<string, blink.cmp.SourceProviderConfigPartial>
return {
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
