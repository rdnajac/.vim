vim.g.loaded_copilot = false
-- vim.cmd([[command! -bang -nargs=? -range=-1 -complete=customlist,copilot#CommandComplete Copilot exe copilot#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)]])
vim.lsp.enable('copilot')
vim.lsp.inline_completion.enable()
vim.keymap.set('i', '<C-J>', function()
  return vim.lsp.inline_completion.get() and '' or '<C-J>'
end, {})

local spec = {
  'folke/sidekick.nvim',
  ---@module "sidekick"
  ---@type sidekick.Config
  opts = {
    cli = {
      mux = {
        backend = 'tmux',
        enable = true,
      },
    },
    nes = { enabled = false },
  },
}
Plug(spec)

local keys = {
  {
    '<c-.>',
    function()
      require('sidekick.cli').focus()
    end,
    desc = 'Sidekick Focus',
    mode = { 'n', 't', 'i', 'x' },
  },
  {
    '<leader>aa',
    function()
      require('sidekick.cli').toggle()
    end,
    desc = 'Sidekick Toggle CLI',
  },
  {
    '<leader>as',
    function()
      require('sidekick.cli').select()
    end,
    -- Or to select only installed tools:
    -- require("sidekick.cli").select({ filter = { installed = true } })
    desc = 'Select CLI',
  },
  {
    '<leader>ad',
    function()
      require('sidekick.cli').close()
    end,
    desc = 'Detach a CLI Session',
  },
  {
    '<leader>at',
    function()
      require('sidekick.cli').send({ msg = '{this}' })
    end,
    mode = { 'x', 'n' },
    desc = 'Send This',
  },
  {
    '<leader>af',
    function()
      require('sidekick.cli').send({ msg = '{file}' })
    end,
    desc = 'Send File',
  },
  {
    '<leader>av',
    function()
      require('sidekick.cli').send({ msg = '{selection}' })
    end,
    mode = { 'x' },
    desc = 'Send Visual Selection',
  },
  {
    '<leader>ap',
    function()
      require('sidekick.cli').prompt()
    end,
    mode = { 'n', 'x' },
    desc = 'Sidekick Select Prompt',
  },
  -- Example of a keybinding to open Claude directly
  {
    '<leader>ac',
    function()
      require('sidekick.cli').toggle({ name = 'claude', focus = true })
    end,
    desc = 'Sidekick Toggle Claude',
  },
}

for _, key in ipairs(keys) do
  vim.keymap.set(key.mode or 'n', key[1], key[2], { desc = key.desc })
end
