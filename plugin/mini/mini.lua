for modname, opt in pairs({
  align = { mappings = { start = 'gA', start_with_preview = 'g|' } },
  extra = {},
  files = { options = { use_as_default_explorer = false } },
  keymap = function()
    local keymap = require('mini.keymap')
    -- FIXME:
    -- local modes = { 'i', 'c', 'x', 's' }
    -- keymap.map_combo(modes, 'jk', '<BS><BS><Esc>')
    -- keymap.map_combo(modes, 'kj', '<BS><BS><Esc>')
    -- keymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    -- keymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
    local notify_many_keys = function(key)
      local lhs = string.rep(key, 5)
      local action = function() vim.notify('Too many ' .. key) end
      keymap.map_combo({ 'n', 'x' }, lhs, action)
    end
    for _, key in pairs(vim.split('h j k l <Up> <Down> <Left> <Right>', ' ', { plain = true })) do
      notify_many_keys(key)
    end

    -- fix typos in insert mode with `kk`
    local action = '<BS><BS><Esc>[s1z=gi<Right>'
    keymap.map_combo('i', 'kk', action)
    return {}
  end,
  misc = {},
  splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' } }, -- TODO: respect shiftwidth
  -- statusline = { },
}) do
  require('mini.' .. modname).setup(vim.is_callable(opt) and opt() or opt)
end
