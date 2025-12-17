vim.cmd.runtime('vimrc')

if vim.env.PROF then
  vim.cmd.packadd('snacks.nvim')
  require('snacks.profiler').startup({})
end

-- stylua: ignore start
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function(...) Snacks.debug.backtrace(...) end
_G.p  = function(...) Snacks.debug.profile(...) end
-- stylua: ignore end

if vim.env.PROF then
  return require('nvim.lazy').bootstrap()
end

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

require('nvim')
