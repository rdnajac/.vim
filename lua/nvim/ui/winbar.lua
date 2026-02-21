-- TODO: add render fucntion thtat handles highlighting
local hl = function(text, group)
  if group then
    return string.format('%%#%s#%s%%*', group, text)
  else
    return text
  end
end

-- local sections = {
-- '',
-- nv.blink.status(),
-- nv.treesitter.status(),
-- nv.lsp.status(),
-- }
-- return table.concat(sections, ' ')

local left_sep = nv.ui.icons.sep.component.rounded.left

local M = {
  active = function()
    local text = ' ' .. '%t'
    return hl(text, 'Chromatophore_a') .. hl(left_sep, 'Chromatophore')
  end,
  inactive = function()
    -- return '%t'
    return '%t'
  end,
}

setmetatable(M, {
  __call = function()
    if vim.bo.filetype == 'snacks_dashboard' then
      return ''
    end
    local active = vim.fn['vimline#active#winbar']() == 1
    if active then
      return M.active()
    else
      return M.inactive()
    end
  end,
})
return M
