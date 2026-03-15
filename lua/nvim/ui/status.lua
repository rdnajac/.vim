local api, fn = vim.api, vim.fn

---@class status.component
---@field [1] string|fun(table?):string
---@field color? string|table
---@field cond? fun():boolean

local M = {}

local function chroma(str, sec) return string.format('%%#Chromatophore_%s#%s', sec, str) end

--- Combines three sections of a statusline/winbar/tabline with appropriate highlighting and separators.
---@param a string?
---@param b string?
---@param c string?
function M.render(a, b, c)
  local sep = nv.ui.icons.sep.component.rounded.left
  return table.concat({
    a and chroma(a, 'a') or '',
    b and chroma(sep .. ' ', 'ab') .. chroma(b, 'b') .. chroma(sep, 'bc') or chroma(sep, 'c'),
    c and chroma(c, 'c') .. chroma(sep, 'cN') or '',
  })
end

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end

---@param str string statusline to be evaluated
---@param opts? vim.api.keyset.eval_statusline
M.debug = function(str, opts)
  opts = opts or {}
  opts.winid = opts.winid or nil
  opts.maxwidth = opts.maxwidth or nil
  opts.fillchar = opts.fillchar or nil
  opts.highlights = opts.highlights or nil
  opts.use_winbar = opts.use_winbar or nil
  opts.use_tabline = opts.use_tabline or nil
  opts.use_statuscol_lnum = opts.use_statuscol_lnum or nil
  return api.nvim_eval_statusline(str, opts)
end

---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

---@return string
M.buffer = function()
  local active = vim._tointeger(vim.g.actual_curwin) == api.nvim_get_current_win()
  local bt = vim.bo.buftype ---@type buftype
  local path
  if bt == '' then
    path = '%t'
  elseif bt == 'terminal' then
    path = fn.fnamemodify(vim.b.osc7_dir or fn.getcwd(), ':~')
  end
  -- TODO:
  -- return "%{% &buftype == 'terminal' ? ' %{&channel}' : '' %}"
  -- return "%{% &buflisted ? '%n' : '󱪟 ' %}" .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
  return table.concat({
    '%h%w%q ', -- help/preview/quickfix
    path or '',
    [[%{% &modified ? '  ' : '' %}]],
    [[%{% &readonly ? '  ' : '' %}]],
    -- [[%{% &busy ? '◐ ' : ''  %}]],
    [[%{% &ff   !=# 'unix'           ? ',ff='..&ff     : '' %}]],
    [[%{% &fenc !~# '^\%(utf-8\)\?$' ? ',fenc='..&fenc : '' %}]],
  })
end

M.git = function()
  local diff = vim.b.minidiff_summary
  return vim
    .iter(ipairs({ 'add', 'change', 'delete' }))
    :map(function(i, key)
      local count = diff and diff[key] or 0
      if count > 0 then
        return string.format('%s%d', ({ ' ', ' ', ' ' })[i], count)
      end
    end)
    :join(' ')
end

-- TODO: Snacks and Snacks.profiler.status()

return M
