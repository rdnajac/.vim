_G.nv = _G.nv or require('nvim.util')

require('nvim.config')

nv.specs = vim
  .iter(nv.submodules('plugins'))
  :map(function(submod)
    return require(submod)
  end)
  :map(function(mod)
    return vim.islist(mod) and mod or { mod }
  end)
  :flatten()
  :map(nv.plug)
  :filter(function(p)
    return p.enabled ~= false
  end)
  :map(function(p)
    return p:tospec()
  end)
  :totable()

vim.pack.add(vim.list_extend(nv.specs, vim.g.plugs or {}), {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec

    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })

    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

Snacks.picker.scriptnames = function()
  require('nvim.snacks.picker.scriptnames')
end

-- TODO: move to util module
local print_debug = function()
  local ft = vim.bo.filetype
  local word = vim.fn.expand('<cword>')
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local templates = {
    -- lua = string.format("print('%s = ' .. vim.inspect(%s))", word, word),
    lua = 'print(' .. word .. ')',
    c = string.format('printf("+++ %d %s: %%d\\n", %s);', row, word, word),
    sh = string.format('echo "+++ %d %s: $%s"', row, word, word),
  }
  local print_line = templates[ft]
  if not print_line then
    return
  end
  vim.api.nvim_buf_set_lines(0, row, row, true, { print_line })
end

vim.keymap.set('n', 'yu', print_debug, { desc = 'Debug <cword>' })
