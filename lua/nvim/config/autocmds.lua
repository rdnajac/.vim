-- autocmd for dir changed to dd(Ev)
local aug = vim.api.nvim_create_augroup('nvimrc', {})

--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param pattern? string|string[]
--- @param cb? fun(ev:vim.api.create_autocmd.callback.args)
local function audebug(event, pattern, cb)
  if type(pattern) == 'function' then
    cb = pattern
    pattern = '*'
  end
  return vim.api.nvim_create_autocmd(event, {
    group = aug,
    pattern = pattern,
    callback = function(ev)
      dd(ev)
    end,
  })
end

audebug('DirChanged')

audebug('DirChanged', function(ev)
  print('Dir changed to: ' .. ev.file)
end)
