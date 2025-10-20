local aug = vim.api.nvim_create_augroup('treesitter', {})

--- @param ft string|string[] filetype or list of filetypes
--- @param override string|nil optional override parser lang
local autostart = function(ft, override)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    group = aug,
    callback = function(args)
      vim.treesitter.start(args.buf, override)
    end,
    desc = 'Automatically start tree-sitter with optional language override',
  })
end

local autostart_filetypes = {
  'markdown',
  'python',
  'yaml',
  'json',
  'html',
  'css',
  'javascript',
  'typescript',
  'toml',
  'vim',
}

return {
  setup = function()
    autostart(autostart_filetypes)
    autostart({ 'sh', 'zsh' }, 'bash')
  end,
}
