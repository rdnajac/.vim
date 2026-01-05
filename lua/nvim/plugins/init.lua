local plugins = vim
  .iter({ 'blink', 'lazy', 'lsp', 'mini', 'treesitter' })
  :fold({}, function(acc, name)
    local spec = require('nvim.' .. name).spec
    return vim.list_extend(acc, spec)
  end)

if not package.loaded['lazy'] then
  local this_dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
  local files = vim.fn.globpath(this_dir, '*', false, true)

  vim
    .iter(files)
    :filter(function(f)
      return not vim.endswith(f, 'init.lua')
    end)
    :map(dofile)
    :each(function(t)
      local spec = vim.islist(t) and t or { t }
      vim.list_extend(plugins, spec)
    end)
end

return plugins
