-- Download `junegunn/vim-plug` to `~/.local/share/nvim/site/autoload/plug.vim`
-- local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
local plug_path = vim.fn.stdpath('config') .. '/autoload/_plug.vim'

if vim.fn.filereadable(plug_path) == 0 then
  local url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  vim.fn.mkdir(vim.fn.fnamemodify(plug_path, ':h'), 'p')
  vim.api.nvim_echo({ { 'Downloading vim-plug...' } }, true, {})
  vim.net.request(
    url,
    { outpath = plug_path },
    vim.schedule_wrap(function(err)
      if err then
        vim.notify('Failed to fetch ' .. url .. ': ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      vim.api.nvim_echo({ { 'Installed ' .. url, 'Normal' } }, true, {})
    end)
  )
end
