-- TODO: configure debuging with
-- nvim_eval_statusline()
track('in vimline')
-- Escape `%` in str so it doesn't get picked as stl item.
local vimlineescape = function(str)
  return nv.is_nonempty_str(str) and str:gsub('%%', '%%%%') or str
end

-- Snacks.util.set_hl({
--   ['1'] = { fg = Snacks.util.color('DiagnosticError'), bg = '#3b4261' },
--   ['2'] = { fg = Snacks.util.color('DiagnosticWarn'), bg = '#3b4261' },
--   ['3'] = { fg = Snacks.util.color('DiagnosticHint'), bg = '#3b4261' },
--   ['4'] = { fg = Snacks.util.color('DiagnosticInfo'), bg = '#3b4261' },
-- }, { prefix = 'User', default = true, managed = true })

-- local sep = ''
M.hostname = vimlineescape(vim.uv.os_gethostname())
M.location = function()
  local line = vim.fn.line('.')
  local col = vim.fn.charcol('.')
  return string.format('%3d:%-2d', line, col)
end

M.selectioncount = function()
  local mode = vim.fn.mode(true)
  local line_start, col_start = vim.fn.line('v'), vim.fn.col('v')
  local line_end, col_end = vim.fn.line('.'), vim.fn.col('.')
  if mode:match('') then
    return string.format(
      '%dx%d',
      math.abs(line_start - line_end) + 1,
      math.abs(col_start - col_end) + 1
    )
  elseif mode:match('V') or line_start ~= line_end then
    return math.abs(line_start - line_end) + 1
  elseif mode:match('v') then
    return math.abs(col_start - col_end) + 1
  else
    return ''
  end
end

M.file = {
  format = function(bufnr)
    return (nv.icons[vim.bo[bufnr or 0].fileformat] or vim.bo[bufnr or 0].fileformat)
  end,

  -- TODO: accept bufnr?
  size = function()
    local size = vim.fn.getfsize(vim.fn.expand('%:p'))

    if size <= 0 then
      return ''
    end

    local suffixes = { 'b', 'k', 'm', 'g' }
    local i = 1

    while size > 1024 and i < #suffixes do
      size = size / 1024
      i = i + 1
    end

    return string.format(i == 1 and '%d%s' or '%.1f%s', size, suffixes[i])
  end,

  ---Return a nicely shortened filename + status symbols.
  ---@param opts? table
  ---  opts.path: 0=tail,1=rel,2=abs,3=abs~,4=parent/leaf  (default 0)
  ---  opts.short_target: columns to leave free (0 = no shorten) (default 40)
  ---  opts.file_status: boolean show [+]/[RO] (default true)
  ---  opts.newfile_status: boolean show [N] for new file (default true)
  ---  opts.symbols: table { unnamed='[No Name]', modified='', readonly='', newfile='' }
  ---  opts.globalstatus: boolean (same meaning as lualine) (default false)
  ---@return string
  name = function(opts)
    opts = opts or {}
    local path_mode = opts.path or 0
    local short_target = opts.short_target or 40
    local file_status = opts.file_status ~= false
    local newfile_status = opts.newfile_status ~= false
    local symbols = opts.symbols
      or {
        unnamed = '[No Name]',
        modified = '',
        readonly = '',
        newfile = '',
      }

    local sep = package.config:sub(1, 1)

    local function is_new_file()
      local fn = vim.fn.expand('%')
      return fn ~= ''
        and fn:match('^%a+://') == nil
        and vim.bo.buftype == ''
        and vim.fn.filereadable(fn) == 0
    end

    local function shorten(path, max_len)
      if #path <= max_len then
        return path
      end
      local segs = vim.split(path, sep)
      for i = 1, #segs - 1 do
        if #path <= max_len then
          break
        end
        local s = segs[i]
        local short = s:sub(1, vim.startswith(s, '.') and 2 or 1)
        segs[i] = short
        path = path:sub(1, 0) -- noop, we recompute len below
        -- recompute quickly:
        -- (#original - #replaced) = delta
      end
      return table.concat(segs, sep)
    end

    local function parent_leaf(p)
      local segs = vim.split(p, sep)
      local n = #segs
      return n <= 1 and p or (segs[n - 1] .. sep .. segs[n])
    end

    -- path pick
    local data
    if path_mode == 1 then
      data = vim.fn.expand('%:~:.')
    elseif path_mode == 2 then
      data = vim.fn.expand('%:p')
    elseif path_mode == 3 then
      data = vim.fn.expand('%:p:~')
    elseif path_mode == 4 then
      data = parent_leaf(vim.fn.expand('%:p:~'))
    else
      data = vim.fn.expand('%:t')
    end
    if data == '' then
      data = symbols.unnamed
    end

    if short_target ~= 0 then
      local ww = opts.globalstatus and vim.go.columns or vim.fn.winwidth(0)
      data = shorten(data, ww - short_target)
    end

    data = vim.fn.substitute(data, [[\%#]], [[\%#]], 'g') -- escape % and |
    data = vim.fn.substitute(data, [[\|]], [[\|]], 'g')

    local marks = {}
    if file_status then
      if vim.bo.modified then
        marks[#marks + 1] = symbols.modified
      end
      if (vim.bo.modifiable == false) or vim.bo.readonly then
        marks[#marks + 1] = symbols.readonly
      end
    end
    if newfile_status and is_new_file() then
      marks[#marks + 1] = symbols.newfile
    end

    return marks[1] and (data .. ' ' .. table.concat(marks, '')) or data
  end,
}

M.clock = {
  {
    function()
      return '  ' .. os.date('%T')
    end,
    separator = { left = ' ' },
  },
}

M.date = {
  function()
    return ' ' .. os.date('%F')
  end,
  color = { gui = 'reverse,bold' },
  -- HACK: force this component to always be on the top right window
  cond = function()
    local winid = vim.api.nvim_get_current_win()
    local current_pos = vim.fn.win_screenpos(winid)
    for _, id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if id ~= winid then
        local pos = vim.fn.win_screenpos(id)
        if pos[1] < current_pos[1] or (pos[1] == current_pos[1] and pos[2] > current_pos[2]) then
          return false
        end
      end
    end
    return true
  end,
}

return M
