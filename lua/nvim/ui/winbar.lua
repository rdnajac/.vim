-- map of buffer types to functions 
-- stylua: ignore
local map = {
  -- probably an oil buffer
  -- [''] = function() return '' end,
  -- acwrite = function() return '' end,
  help = function() return '%h' end,
  -- nofile = function() return '' end,
  -- nowrite = function() return '' end,
  -- prompt = function() return '' end,
  quickfix = function() return '%q' end,
  terminal = function() return vim.fn["vimline#winbar#term"]() end,
}

function MyWinBar()
  -- - <empty>	normal buffer
  -- - acwrite	buffer will always be written with |BufWriteCmd|s
  -- - help	help buffer (do not set this manually)
  -- - nofile	buffer is not related to a file, will not be written
  -- - nowrite	buffer will not be written
  -- - prompt	buffer where only the last section can be edited
  -- - quickfix	list of errors |:cwindow| or locations |:lwindow|
  -- - terminal	|terminal-emulator| buffer
  local bt = vim.bo.buftype
  if bt and bt ~= '' then
    -- special buffer types
    if vim.tbl_contains(vim.tbl_keys(map), bt) then
      return map[bt]()
    end
  end
  return vim.fn['vimline#winbar#']()
end
