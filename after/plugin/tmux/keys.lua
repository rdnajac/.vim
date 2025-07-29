-- Function to capture tmux key bindings using vim.system
local function capture_tmux_keys()
  local result = vim.system({ 'tmux', 'list-keys', '-N' }, { text = true }):wait()

  -- Split the result by newlines into []
  local keys = vim.split(result.stdout, '\n', { plain = true })
  local filtered_keys = {}

  -- Iterate through each line and capture key bindings
  for _, key in ipairs(keys) do
    local prefix, lhs, desc = key:match('^(%S+)%s+(%S+)%s+(.+)$')

    -- If the key is not a number (0-9), then add to filtered_keys table
    if prefix and key and desc and not key:match('^[0-9]$') then
      -- if the key is more than one character, wrap it in `<` and `>`
      if #lhs > 1 then
        lhs = '<' .. lhs .. '>'
      end

      filtered_keys[#filtered_keys + 1] = { '<C-W>' .. lhs, '', group = 'tmux', desc = desc }
    end
  end
  return filtered_keys
end

-- Run the function to capture tmux key bindings
local key_bindings = capture_tmux_keys()
-- print(vim.inspect(key_bindings))

-- require('which-key').add({
--   { '<C-F>', group = 'tmux' },
--   { '<C-F>:', desc = 'tmux' },
--   key_bindings,
-- })

-- some vim window key bindings overlap
--   `d` ➜ 󱖫 Show diagnostics under the cursor │
-- skip

--   `w` ➜  Switch windows                    │

--   `x` ➜  Swap current with next            │
-- use capital x

--   `L` ➜  Move window to far right          │
-- skip

--   `=` ➜  Equally high and wide             │
--   `|` ➜  Max out the width                 │
