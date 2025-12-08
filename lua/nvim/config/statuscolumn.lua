local nv = _G.nv or {}

nv.statuscolumn = function()
  if not Snacks then
    return ''
  end

  local sstc = Snacks.statuscolumn.get()
  if vim.bo.filetype == 'dirvish' or vim.bo.buftype == 'terminal' then
    -- if vim.bo.buftype == 'nofile' then
    return sstc
  end
  -- remove the click fold
  sstc = sstc:gsub("%%@v:lua%.require'snacks%.statuscolumn'%.click_fold@(.-)%%T", '%1')
  -- dd(sstc)
  -- if vim.bo.buftype ~= '' and not nv.fn.is_curwin then
  -- split into components
  local left, num, right = sstc:match('^(.-)%%=(%d+)(.*)$')
  local ret
  -- left signs override numbers
  if left and vim.trim(left) ~= '' then
    ret = left .. ' '
  elseif num then
    local width = tonumber(num) > 999 and 4 or 3
    ret = string.format('%-' .. width .. 's', num)
  else
    ret = string.rep(' ', 3)
    -- ret = '   '
  end
  -- local ret2 = right and vim.trim(right) ~= '' and right or ''
  -- return string.format([[%s%s]], ret, ret2)
  local sep = '▎'
  -- local sep = '▏'
  return string.format('%%=%s%s', ret, sep)
end

vim.o.statuscolumn = '%!v:lua.nv.statuscolumn()'
