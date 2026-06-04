---@return string?
local tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return '<C-y>'
  end
  if package.loaded['blink.cmp'] and require('blink.cmp').select_and_accept() then
    return
  end
  -- if there is a next edit, jump to it, otherwise apply it if any
  if package.loaded['sidekick'] and require('sidekick').nes_jump_or_apply() then
    return -- jumped or applied
  end
  if vim.lsp.inline_completion.get() then
    return
  end
  return '<Tab>' -- fallback
end

return tab
