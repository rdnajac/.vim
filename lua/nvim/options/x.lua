-- XXX: experimental!
if vim.fn.has('nvim-0.12') == 1 then
  require('vim._extui').enable({
    -- target = 'msg',
  })
end

if not LazyVim.has('lualine') then
  local cmd_group = vim.api.nvim_create_augroup('cmdline', { clear = true })
  vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = cmd_group,
    callback = function(args)
      if vim.bo[args.buf].filetype ~= 'snacks_dashboard' then
        vim.api.nvim_create_autocmd('CmdlineLeave', {
          once = true,
          callback = function()
            vim.o.laststatus = 3
          end,
        })
        vim.o.laststatus = 0
      end
    end,
  })

  vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = cmd_group,
    command = 'set laststatus=0',
  })
end
