local hipatterns = require('mini.hipatterns')

-- Helper function to check if a position is in a comment
local function in_comment(buf_id, lnum, col)
  -- Check if TreeSitter is active for this buffer
  if vim.treesitter.highlighter.active[buf_id] then
    local nv = require('nvim.util')
    return nv.treesitter.is_comment({ lnum, col })
  end
  -- Fallback to syntax-based detection
  local synid = vim.fn.synID(lnum + 1, col + 1, 1)
  local name = vim.fn.synIDattr(synid, 'name')
  return name and name:find('Comment') ~= nil
end

-- #39FF14
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    -- Highlight backtick-enclosed text within comments
    backticks_in_comments = {
      pattern = '`[^`\n]+`',
      group = 'Chromatophore',
      extmark_opts = function(_, match, data)
        -- Skip bigfiles early to avoid expensive comment detection
        if vim.bo[data.buf_id].filetype == 'bigfile' then
          return nil
        end
        -- Check if the match is inside a comment
        -- Mini.hipatterns uses 1-indexed line_num, convert to 0-indexed for in_comment
        if in_comment(data.buf_id, data.line_num - 1, data.from_col - 1) then
          return {
            hl_mode = 'combine',
            priority = 10000,
            spell = false,
          }
        end
        return nil
      end,
    },
    -- if not using todo-comments
    -- fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    -- warning = { pattern = 'WARNING', group = 'MiniHipatternsFixme' },
    -- hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    -- section = { pattern = 'Section', group = 'MiniHipatternsHack' },
    -- todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    -- note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    -- perf = { pattern = 'PERF', group = 'MiniHipatternsNote' },
  },
})
