local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'

if vim.fn.filereadable(plug_path) == 0 then
  local url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim.net.request(
    url,
    { retry = 3, outpath = plug_path },
    vim.schedule_wrap(function(err, _)
      if err then
        vim.notify('Failed to fetch ' .. url .. ': ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      vim.api.nvim_echo({ { 'Loaded ' .. url, 'Normal' } }, true, {})
    end)
  )
end
