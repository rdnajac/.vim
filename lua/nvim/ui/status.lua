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

---@param opts? vim.api.keyset.eval_statusline
---             - winid: (number) |window-ID| of the window to use as context
---             - maxwidth: (number) Maximum width of statusline.
---             - fillchar: (string) Character to fill blank spaces in the statusline
---             - highlights: (boolean) Return highlight information.
---             - use_winbar: (boolean) Evaluate winbar instead of statusline.
---             - use_tabline: (boolean) Evaluate tabline instead of statusline.
---             - use_statuscol_lnum: nv.winbar(opts))(number) Evaluate statuscolumn for this line number
M.debug = function(str, opts)
  opts = opts or {}
  -- opts.use_winbar = true
  return vim.api.nvim_eval_statusline(str, opts)
end

---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

---@param opts? {bufnr?:integer,win?:integer,bt?:string,ft?:string,active?:boolean}
---@return string
M.buffer = function(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local win = opts.win or vim.api.nvim_get_current_win()
  local bt = opts.bt or vim.bo[bufnr].buftype
  local ft = opts.ft or vim.bo[bufnr].filetype
  local path

  if bt == '' then
    local active = opts.active or (win == tonumber(vim.g.actual_curwin))
    -- path = active and '%t' or '%f'
    -- path = active and nv.path.relative_parts(bufnr)[2] or '%t'
    path = '%'
  elseif bt == 'help' then
    path = '%t'
  elseif bt == 'terminal' then
    path = vim.fn.fnamemodify(vim.b[bufnr].osc7_dir or vim.fn.getcwd(), ':~')
  end

  return table.concat({
    '%h%w%q ', -- help/preview/quickfix
    path or '',
    --- XXX: why no opening `%`
    [[{% &readonly ? ' ' : '%M' %}]],
    [[%{% &busy     ? '◐ ' : ''   %}]],
    [[%{% &ff !=# 'unix'  ? ' ff=' . &ff : ''  %}]], -- TODO: add icon
    [[%{% &fenc !=# 'utf-8' && &fenc !=# ''  ? ' fenc=' . &fenc : ''  %}]],
  })
end

return M
