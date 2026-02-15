local M = {
  active = function()
    local sections = {
      '',
      -- nv.blink.status(),
      nv.treesitter.status(),
      -- nv.lsp.status(),
    }
    return table.concat(sections, ' ')
  end,
  inactive = function()
    -- return '%t'
    return '%t'
  end,
}

setmetatable(M, {
  __call = function(_, ...)
    local args = { ... }
    local active = vim.fn['vimline#active#winbar']() == 1
    if active then
      return M.active(...)
    else
      return M.inactive(...)
    end
  end,
})
return M
