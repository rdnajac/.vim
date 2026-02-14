local M = {
  active = function()
    local sections = {
      '',
      nv.blink.status(),
      -- nv.treesitter.status(),
      -- nv.lsp.status(),
    }
    return table.concat(sections, ' ')
  end,
  inactive = function()
    -- return '%t'
    return '%t'
  end,
}

return M
