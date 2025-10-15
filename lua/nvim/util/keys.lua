local map = {
  tmux = {
    cmd = { 'tmux', 'list-keys', '-N' },
  },
  ghostty = {
    cmd = { 'ghostty', '+list-keybinds' },
  },
}

-- Function to capture tmux key bindings using vim.system
local function capture_external_keybinds(tool)
  local cmd = map[tool].cmd
  local result = vim.system(cmd, { text = true }):wait()
  local keys = vim.split(result.stdout, '\n', { plain = true, trimempty = true })
  -- ...
  return keys
end

local function capture_tmux_keys()
  local keys = vim.tbl_map(function(k)
    local prefix, lhs, desc = k:match('^(%S+)%s+(%S+)%s+(.+)$')
    lhs = #lhs > 1 and '<' .. lhs .. '>' or lhs
    -- lhs = '<C-b>' .. lhs
    -- return { keymap = lhs, action = desc }
    return { [lhs] = desc }
  end, capture_external_keybinds('tmux'))
  return keys
end

print(capture_tmux_keys())

local function capture_ghostty_keys()
  local keys = vim.tbl_map(function(k)
    local keymap, action = k:sub(#'keybind =  '):match('^(.+)=(.+)$')
    return { keymap = keymap, action = action }
  end, capture_external_keybinds('ghostty'))
  -- additional processing goes here
  return keys
end

-- print(capture_ghostty_keys())
