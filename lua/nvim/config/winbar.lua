-- - <empty>	normal buffer
-- - acwrite	nvim-pack, oil
-- - help	help buffer (do not set this manually)
-- - nofile	buffer is not related to a file, will not be written
-- - nowrite	buffer will not be written
-- - prompt	buffer where only the last section can be edited
-- - quickfix	list of errors |:cwindow| or locations |:lwindow|
-- - terminal	|terminal-emulator| buffer
-- stylua: ignore
local map = {
-- TODO: tuple icon + text
  [''] = function() return  vim.fn['vimline#winbar#']() end,
  acwrite = function() return vim.fn['vimline#winbar#acwrite']() end,
  help = function() return '󰋖  %f' end,
  nofile = function() return '  ' .. os.date('%T') end,
  nowrite = function() return '[NOWRITE]' end,
  prompt = function() return '[PROMPT]' end,
  quickfix = function() return '%q' end,
  terminal = function() return vim.fn["vimline#winbar#terminal"]() end,
}

-- snacks scratch? buftype = ''
-- noflisted

local M = setmetatable({}, {
  __call = function(M, ...)
    return M.winbar(...)
  end,
})

function M.winbar()
  return vim.bo.filetype == 'snacks_dashboard' and '' or map[vim.bo.buftype]()
end

function M.setup()
  nv.winbar = M.winbar
  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end

return M
