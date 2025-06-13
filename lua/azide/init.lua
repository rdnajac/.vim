local stub_win, oil_win

local function open_oil_with_stub()
  local oil = require('oil')
  vim.cmd('Oil --float')

  vim.defer_fn(function()
    oil_win = vim.api.nvim_get_current_win()
    if stub_win and vim.api.nvim_win_is_valid(stub_win) then
      return
    end

    vim.cmd('topleft 30vsplit +enew')
    stub_win = vim.api.nvim_get_current_win()
    local stub_buf = vim.api.nvim_get_current_buf()
    vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodifiable readonly')

    vim.api.nvim_create_autocmd('BufEnter', {
      buffer = stub_buf,
      callback = function()
        if oil_win and vim.api.nvim_win_is_valid(oil_win) then
          vim.defer_fn(function()
            vim.api.nvim_set_current_win(oil_win)
          end, 0)
        end
      end,
    })

    vim.api.nvim_create_autocmd('WinClosed', {
      group = ooze_group,
      callback = function(args)
        local closed = tonumber(args.match)
        if closed == oil_win or closed == stub_win then
          if stub_win and vim.api.nvim_win_is_valid(stub_win) then
            vim.api.nvim_win_close(stub_win, true)
          end
          stub_win = nil
          oil_win = nil
        end
      end,
    })

    vim.api.nvim_set_current_win(oil_win)
  end, 10)
end

local oil = require('oil')
local is_oil = vim.w.is_oil_window

local add_oil = function()
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  if entry.type == 'directory' then
    require('oil.actions').select.callback()
    return
  end

  local path = oil.get_current_dir() .. entry.name
  local curr_win = vim.api.nvim_get_current_win()

  vim.cmd('wincmd p')
  vim.cmd('edit ' .. vim.fn.fnameescape(path))
  vim.api.nvim_set_current_win(curr_win)
end

