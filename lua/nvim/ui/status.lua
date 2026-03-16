local api, fn, fs = vim.api, vim.fn, vim.fs

---@class status.component
---@field [1] string|fun(table?):string
---@field color? string|table
---@field cond? fun():boolean

local M = {}

local icons = require('nvim.ui.icons')
local function chroma(str, sec) return string.format('%%#Chromatophore_%s#%s', sec, str) end

--- Combines three sections of a statusline/winbar/tabline with appropriate highlighting and separators.
---@param a string?
---@param b string?
---@param c string?
function M.render(a, b, c)
  local sep = icons.sep.component.rounded.left
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

local git_hl_map = {
  -- 'MiniDiffSignAdd',
  -- 'MiniDiffSignChange',
  -- 'MiniDiffSignDelete',
  'DiagnosticSignHint',
  'DiagnosticSignWarn',
  'DiagnosticSignError',
}

---@param icons string[]
---@param hl_map? string[]
---@return fun(counts: table<number, integer>): string
M.render_counts = function(icons, hl_map)
  return function(counts)
    return vim
      .iter(ipairs(icons))
      :map(function(i, _) return i, counts[i] or 0 end)
      :filter(function(_, count) return count > 0 end)
      :map(function(i, count)
        local rv = ('%s %d'):format(icons[i], count)
        return hl_map and hl_map[i] and ('%%$%s$%s'):format(hl_map[i], rv) or rv
      end)
      :join(' ')
  end
end

local render_git_counts = M.render_counts({ '', '', '' }, git_hl_map)

M.git = function()
  local diff = vim.b.minidiff_summary or {}
  return render_git_counts({
    diff.add or 0,
    diff.change or 0,
    diff.delete or 0,
  })
end

local parts = {
  [[%<%f %h%w%m%r ]], -- path, help, preview, modified, readonly
  [[%{% v:lua.require('vim._core.util').term_exitcode() %}]],
  [[%=]], -- right align the rest
  [[%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}]],
  [[%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}]],
  [[%{% &busy > 0 ? '◐ ' : '' %}]],
  [[%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}]],
  [[%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}]],
}

-- local orig_statusline = vim.o.statusline
-- assert(orig_statusline == table.concat(parts))

M.line = function()
  local cwd = fn.getcwd()
  local file = vim.api.nvim_buf_get_name(0)
  local a = ' ' .. fn.fnamemodify(cwd, ':~') .. '/'
  local b = fs.relpath(cwd, file) .. ' %h%w%q%m%r'
  local c = ' ' .. M.git()
  parts[1] = M.render(a, b, c)
  return table.concat(parts)
end

return M
