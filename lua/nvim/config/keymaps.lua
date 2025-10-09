-- vim.keymap.set('n', 'zS', vim.showpos)
vim.keymap.set('n', '<leader>ui', vim.show_pos)
vim.keymap.set('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Tree' })

-- stylua: ignore start
vim.keymap.set({'n','t'}, '<c-\\>', function() Snacks.terminal.toggle() end)
vim.keymap.set('v', '<leader>/', function() Snacks.picker.grep_word() end)
vim.keymap.set('n', '<leader>sW', 'viW<Cmd>lua Snacks.picker.grep_word()<CR>', { desc = 'Grep <cWORD>' })
-- stylua: ignore end

return {
  setup = function()
    local wk = require('which-key')
    for name, keys in pairs(nv.todo.keys) do
      nv.did.keys[name] = wk.add(keys)
    end

    Snacks.util.on_key('<Esc>', function()
      vim.cmd.nohlsearch()
      if package.loaded['sidekick'] then
        require('sidekick').clear()
      end
    end)

    Snacks.util.on_key('<C-Space>', function()
      if package.loaded['sidekick'] then
        require('sidekick').clear()
      end
    end)
  end,
}
