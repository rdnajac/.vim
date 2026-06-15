-- lua vim.bo.syntax = 'ON'
if vim.g.old_bg == nil then
  vim.g.old_bg = Snacks and Snacks.util.color('LspReferenceText', 'bg')
    or ('#%06x'):format(
      vim.api.nvim_get_hl(0, { name = 'LspReferenceText', link = false, create = false }).bg
    )
end

local lsp_ref_bg = function(bg)
  if not Snacks then
    return ('hi! LspReferenceText guibg=%s'):format(bg)
  end
  return ([[lua Snacks.util.set_hl({ LspReferenceText = { bg = '%s' } })]]):format(bg)
end

--- create a buffer-local autocommand
---@param event string|string[]
---@param cmd string
local au = function(event, cmd) vim.api.nvim_create_autocmd(event, { command = cmd, buf = 0 }) end

au({ 'CursorHold', 'CursorHoldI' }, lsp_ref_bg(vim.g.old_bg))
au({ 'CursorMoved', 'CursorMovedI' }, lsp_ref_bg('NONE'))
