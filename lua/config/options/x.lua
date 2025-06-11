-- XXX: experimental!
if vim.fn.has('nvim-0.12') == 1 then
  require('vim._extui').enable({
    msg = {
      pos = 'box',
      box = { timeout = 2000 },
    },
  })
end
