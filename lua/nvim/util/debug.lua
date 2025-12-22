local M = {}

local debug_r = function()
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- copy the <cword> to a new line below the current line
  vim.api.nvim_buf_set_lines(0, row, row, true, { word })
  -- move cursor to the new line
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  -- execute <Plug>RInsertLineOutput from normal mode
  vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
  -- delete the line with the word
  vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
  -- move cursor back to original position
  vim.api.nvim_win_set_cursor(0, { row, col })
end

local print_debug = function()
  local ft = vim.bo.filetype
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local word = vim.fn.expand('<cWORD>')
  if word:sub(-1) == ',' then
    word = word:sub(1, -2)
  end
  local templates = {
    -- lua = string.format("print('%s = ' .. vim.inspect(%s))", word, word),
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
    r = word,
    vim = ([[echom %s]]):format(word),
  }
  if vim.tbl_contains(vim.tbl_keys(templates), ft) then
    vim.api.nvim_buf_set_lines(0, row, row, true, { templates[ft] })
  end
end

M.print = function()
  if vim.bo.filetype == 'r' and package.loaded['r'] then
    return debug_r()
  end
  print_debug()
end

M.source = function()
  local me = debug.getinfo(1, 'S')
  -- .source:sub(2) when to sub? @...
  local dir = vim.fs.dirname(me.source:sub(2))

  local i = 1
  while true do
    i = i + 1
    -- info and (info.source == me.source or info.source == '@' .. vim.env.MYVIMRC or info.what ~= 'Lua')
    local info = debug.getinfo(i, 'S')
    if not info then
      error('Could not `debug.getinfo()`')
    end

    local src = info.source
    -- source = vim.uv.fs_realpath(source) or source
    src = src:sub(1, 1) == '@' and src:sub(2) or src
    if not vim.startswith(src, dir) then
      return vim.fs.abspath(src)
    end
  end
  return src .. ':' .. info.linedefined
end

local get_upvalue = function(func, name)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      dd(n)
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

-- local func = Snacks.picker.local
-- get_upvalue(func, name)

function M.set_upvalue(func, name, value)
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      debug.setupvalue(func, i, value)
      return
    end
    i = i + 1
  end
  error('upvalue not found: ' .. name)
end

return M
