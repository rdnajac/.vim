local M = {}

-- stylua: ignore
local map = {
  [''] = function() return  vim.fn['vimline#winbar#']() end,
  acwrite = function() return vim.fn['vimline#winbar#acwrite']() end,
  help = function() return '%h' end,
  nofile = function() return '  ' .. os.date('%T') end,
  nowrite = function() return '[NOWRITE]' end,
  prompt = function() return '[PROMPT]' end,
  quickfix = function() return '%q' end,
  terminal = function() return vim.fn["vimline#winbar#terminal"]() end,
}

M.winbar = function()
  -- - <empty>	normal buffer
  -- - acwrite    nvim-pack, oil
  -- - help	help buffer (do not set this manually)
  -- - nofile	buffer is not related to a file, will not be written
  -- - nowrite	buffer will not be written
  -- - prompt	buffer where only the last section can be edited
  -- - quickfix	list of errors |:cwindow| or locations |:lwindow|
  -- - terminal	|terminal-emulator| buffer
  return map[vim.bo.buftype]()
end

M.config = function()
  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end()

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
