vim.cmd.runtime('vimrc')

if vim.env.PROF then
  vim.cmd.packadd('snacks.nvim')
  require('snacks.profiler').startup({
    -- startup = { event = 'UIEnter' },
  })
end

require('nvim')

-- TODO: decouple the custom loading from the plugin management
-- emit an autcmd like jetpack and hook the setup funcs to those autocmds
vim.pack.add(nv.specs, {
  -- confirm = false,
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    local name = spec.name
    vim.cmd.packadd({ args = { name }, bang = true, magic = { file = false } })
    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})
-- require('lazy').init()
