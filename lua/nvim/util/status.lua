---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

-- Statusline component
-- function M.status()
--   return {
--     function()
--       return ("%s %d events"):format(M.config.icons.status, #M.core.events)
--     end,
--     color = "DiagnosticError",
--     cond = function()
--       return M.core.running
--     end,
--   }
-- end

local M = {}

M.a = function(opts)
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local win = opts.win or vim.api.nvim_get_current_win()
  local bt = opts.bt or vim.bo[bufnr].buftype
  local ft = opts.ft or vim.bo[bufnr].filetype
  local path

  if bt == '' then
    local active = opts.active or (win == tonumber(vim.g.actual_curwin))
    -- path = active and '%t' or '%f'
    path = active and nv.path.relative_parts(bufnr)[2] or '%t'
  elseif bt == 'help' then
    path = '%t'
  elseif bt == 'terminal' then
    path = vim.fn.fnamemodify(vim.b[bufnr].osc7_dir or vim.fn.getcwd(), ':~')
  end

  return table.concat({
    '%h%w%q ', -- help/preview/quickfix
    path or '',
    [[%{% &readonly ? ' ' : '%M' %}]],
    [[%{% &busy     ? '◐ ' : ''   %}]],
    [[%{% &ff !=# 'unix'  ? ' ff=' . &ff : ''  %}]],
    [[%{% &fenc !=# 'utf-8' && &fenc !=# ''  ? ' fenc=' . &fenc : ''  %}]],
  })
end

function M.render(a, b, c)
  local function sec(s, str)
    return string.format('%%#Chromatophore_%s#%s', s, str)
  end
  local sep = nv.icons.sep.component.rounded.left
  local sec_a = a and sec('a', a) or nil
  local sec_b = b and sec('ab', sep .. ' ') .. sec('b', b) .. sec('bc', sep) or sec('c', sep)
  local sec_c = c and sec('c', c) or ''
  -- return string.format('%s%s%s', sec_a, sec_b, sec_c)
  return table.concat({ sec_a, sec_b, sec_c })
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

return M
