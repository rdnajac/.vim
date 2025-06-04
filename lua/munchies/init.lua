_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.bt = function()
  Snacks.debug.backtrace()
end

vim.print = _G.dd -- Override print to use snacks for `:=` command

vim.cmd([[
  command! Chezmoi     :lua require('munchies.picker').chezmoi()
  command! Scriptnames :lua require('munchies.picker').scriptnames()
]])

require("munchies.toggle").flag({
  name = "oil_sidebar_enabled",
  default = 0,
  mapping = "<leader>e",
  desc = "Toggle Oil Sidebar",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksToggle:oil_sidebar_enabled",
  callback = function(ev)
    local enabled = ev.data.value
    if enabled then
      vim.cmd('topleft 30vsplit | Oil')
      vim.cmd('wincmd l')
    else
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'oil' then
          vim.api.nvim_win_close(win, true)
        end
      end
    end
  end,
})
