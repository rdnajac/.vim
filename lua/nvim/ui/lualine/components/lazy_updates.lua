return {
  function()
    if require('lazy.status').has_updates() then
      return require('lazy.status').updates() .. ' 󰒲 '
    end
    return ''
  end,
  cond = require('lazy.status').has_updates,
}
