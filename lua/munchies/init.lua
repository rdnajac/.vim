local aug = vim.api.nvim_create_augroup('munchies', { clear = true })
local au = function(ev, pattern, cb)
  vim.api.nvim_create_autocmd(ev, {
    pattern = pattern,
    group = aug,
    callback = cb,
  })
end

au('FileType', { 'lua' }, function()
  Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
end)

au('FileType', { 'help', 'man', 'qf' }, function(ev)
  if Snacks.util.is_transparent() then
    Snacks.util.wo(0, { winhighlight = { Normal = 'SpecialWindow' } })
  end
end)

require('munchies.chromatophore')
require('munchies.commands')
require('munchies.keymaps')
require('munchies.lspprogress')
