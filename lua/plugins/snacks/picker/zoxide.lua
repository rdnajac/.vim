local M = {}

M.cd = function()
  return Snacks.picker.zoxide({
    confirm = function(picker, item)
      picker:close()
      vim.cmd('cd ' .. vim.fn.fnameescape(item.file))
      vim.cmd('pwd')
    end,
  })
end

M.edit = function()
  return Snacks.picker.zoxide({
    confirm = { 'edit' },
  })
end

M.pick = function(bang)
  if bang == '!' then
    return M.edit()
  else
    return M.cd()
  end
end

function M.cd_and_resume_picking(self)
  self:close()
  Snacks.picker.zoxide({
    confirm = function(_, item)
      vim.cmd('cd ' .. vim.fn.fnameescape(item.file))
      vim.cmd('pwd')
      Snacks.picker.resume({ cwd = item.file })
    end,
  })
end

return M
