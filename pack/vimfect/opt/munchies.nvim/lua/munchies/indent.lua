return {
  indent = {
    priority = 1,
    enabled = true, -- enable indent guides
    char = '│',
    only_scope = false, -- only show indent guides of the scope
    only_current = false, -- only show indent guides in the current window
    -- can be a list of hl groups to cycle through
    hl = 'SnacksIndent', ---@type string|string[] hl groups for indent guides
  },
  animate = {
    style = 'out', -- "out"|"up_down"|"down"|"up"
    easing = 'linear',
    duration = {
      step = 42, -- ms per step
      total = 500, -- maximum duration
    },
  },
  ---@class snacks.indent.Scope.Config: snacks.scope.Config
  scope = {
    enabled = true, -- enable highlighting the current scope
    priority = 200,
    char = '│',
    underline = false, -- underline the start of the scope
    only_current = false, -- only show scope in the current window
    hl = 'SnacksIndentScope', ---@type string|string[] hl group for scopes
  },
  chunk = {
    -- when enabled, scopes will be rendered as chunks, except for the
    -- top-level scope which will be rendered as a scope.
    enabled = false,
    -- only show chunk scopes in the current window
    only_current = false,
    priority = 200,
    hl = 'SnacksIndentChunk', ---@type string|string[] hl group for chunk scopes
    char = {
      corner_top = '┌',
      corner_bottom = '└',
      -- corner_top = "╭",
      -- corner_bottom = "╰",
      horizontal = '─',
      vertical = '│',
      arrow = '>',
    },
  },
}
