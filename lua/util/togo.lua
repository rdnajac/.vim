--- Edit a file if it is readable, otherwise optionally display a warning.
--- @param file string: The path to the file to edit.
--- @param should_warn? boolean: Whether to warn if the file is not found.
--- @return boolean: True if the file was successfully edited, false otherwise.
local function edit(file, should_warn)
  if vim.fn.filereadable(file) == 1 then
    if Snacks.util.is_float() then
      vim.cmd('q')
    end
    vim.cmd('edit ' .. file)
    return true
  else
    if should_warn then
      Snacks.notify.warn('File not found: ' .. file)
    end
    return false
  end
end

local M = {}

M.lazy = function()
  local LazyVimPath = lazypath .. '/LazyVim'
  local ft = vim.bo.filetype
  local word = vim.fn.expand('<cWORD>'):gsub('[,\'"]', ''):gsub('%.', '/')
  local target

  if ft == 'lazy' then
    target = LazyVimPath .. '/lua/lazyvim/plugins/extras/' .. word .. '.lua'
  elseif ft == 'lua' then
    target = LazyVimPath .. '/lua/' .. word .. '.lua'
  else
    Snacks.notify.warn('Unsupported filetype: ' .. ft)
    return
  end

  edit(target)
end

function M.gx()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.')
  local pattern = '["\']([%w_-]+/[%w_.-]+)["\']'

  for start_idx, quoted in line:gmatch('()' .. pattern) do
    local finish = start_idx + #quoted - 1
    if col >= start_idx and col <= finish then
      vim.cmd('silent! !open https://github.com/' .. quoted)
      return
    end
  end

  vim.cmd('normal! gx')
end

return M
