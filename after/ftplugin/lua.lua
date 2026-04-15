if vim.g.loaded_endwise == 1 then
  vim.bo.syntax = 'ON' -- use legacy syntax
end

if _G.MiniSplitjoin then
  local gen_hook = MiniSplitjoin.gen_hook
  local curly = { brackets = { '%b{}' } }
  local add_comma_curly = gen_hook.add_trailing_separator(curly)
  local del_comma_curly = gen_hook.del_trailing_separator(curly)
  local pad_curly = gen_hook.pad_brackets(curly)
  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  }
end

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
