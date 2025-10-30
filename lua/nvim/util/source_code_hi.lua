-- highlights `src` in backticks ( ` ) using Mini.hipatterns

-- Helper function to check if position is inside a comment
local function in_comment(buf_id, line, col)
  -- Use treesitter if available
  if vim.treesitter.highlighter.active[buf_id] then
    return nv.treesitter.is_comment({ line, col })
  end
  -- Fallback to syntax highlighting
  local synid = vim.fn.synID(line + 1, col + 1, 1)
  local name = vim.fn.synIDattr(synid, 'name')
  return name and name:find('Comment') ~= nil
end

-- Computed highlighter for backticks in comments
-- This function is called during highlighting to determine what to highlight
return {
  pattern = '`[^`\n]+`',
  group = function(buf_id, match, data)
    -- data.line is 1-indexed, data.from_col is 1-indexed
    local line = data.line - 1 -- Convert to 0-indexed for in_comment
    local col = data.from_col - 1 -- Convert to 0-indexed for in_comment

    -- Only return highlight group if inside a comment
    if in_comment(buf_id, line, col) then
      return 'Chromatophore'
    end

    return nil -- Don't highlight if not in a comment
  end,
  extmark_opts = {
    priority = 10000,
    hl_mode = 'combine',
    spell = false,
  },
}
