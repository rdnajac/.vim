local minimods = {
  'align',
  'ai',
  'diff',
  'hipatterns',
  'icons',
  -- 'splitjoin',
  -- 'surround',
}

local minisetup = function(minimod)
  local ok, mod = pcall(require, 'nvim.mini.' .. minimod)
  if not ok then
    require('mini.' .. mod).setup({})
  end
end

-- PERF: only plug the individual modules
if vim.g.mini_exclusive == true then
  -- setup()
  return {
    vim.tbl_map(function(m)
      return {
        'nvim-mini/mini.' .. m,
        config = minisetup(m),
      }
    end, minimods),
  }
end

return {
  'nvim-mini/mini.nvim',
  config = function()
    vim.schedule(function()
      vim.tbl_map(minisetup, minimods)
    end)
  end,
}
