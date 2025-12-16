vim.pack.add(
  vim.tbl_map(function(plugin)
    return 'https://github.com/folke/' .. plugin .. '.nvim.git'
  end, { 'snacks', 'tokyonight', 'which-key' }),
  {
    load = function(data)
      vim.cmd.packadd({ data.spec.name, bang = true })
      require('nvim.folke.' .. data.spec.name:sub(1, -6))
    end,
  }
)

return {
  spec = require('nvim.folke.lazy').spec,
}
