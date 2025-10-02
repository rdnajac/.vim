-- vim.g.health = { style = 'float' }
-- for _, provider in ipairs({ 'node', 'perl', 'ruby' }) do
--   vim.g[provider] = 0 -- disable to silence warnings
-- end
return {
  name = 'nvim_config',
  keys = require('nvim.config.keymaps'),
  commands = require('nvim.config.commands'),
  config = function()
    nv.lazyload(function()
      require('nvim.config.sourcecode').setup()
      require('nvim.config.autocmds')()
      vim.o.winbar = '%{%v:lua.nv.winbar()%}'
    end)
  end,
}
