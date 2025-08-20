return {
  'j-hui/fidget.nvim',
  config = function()
    require('fidget').setup({
      -- notification = {
      --   redirect = function(msg, level, opts)
      --     local text =  require('fidget.progress.display').default_format_message(msg)
      --     vim.notify(text, level or vim.log.levels.INFO, opts)
      --     return true
      --   end,
      -- },
    })
  end,
}
