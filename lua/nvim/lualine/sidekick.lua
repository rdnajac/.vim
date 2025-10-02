local sidekick_component = {
  function()
    local status = require('sidekick.status').get()
    return status and vim.tbl_get(nv.icons.copilot, status.kind, 1)
  end,
  cond = function()
    return require('sidekick.status').get() ~= nil
  end,
  color = function()
    local status = require('sidekick.status').get()
    local hl = status and (status.busy and 'DiagnosticWarn' or vim.tbl_get(icons, status.kind, 2))
    return { fg = Snacks.util.color(hl) }
  end,
}
return sidekick_component
