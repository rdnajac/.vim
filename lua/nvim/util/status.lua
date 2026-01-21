---@class status.component
---@field [1] string|fun(table?):string
---@field color? string|table
---@field cond? fun():boolean

local M = {}

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
    [[%{% &readonly ? ' ' : '%M' %}]],
    [[%{% &busy     ? '◐ ' : ''   %}]],
    [[%{% &ff !=# 'unix'  ? ' ff=' . &ff : ''  %}]],
    [[%{% &fenc !=# 'utf-8' && &fenc !=# ''  ? ' fenc=' . &fenc : ''  %}]],
  })
end

function M.render(a, b, c)
  local function sec(s, str) return string.format('%%#Chromatophore_%s#%s', s, str) end
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

M.R = function()
  Snacks.util.set_hl({
    Inactive = { fg = '#aaaaaa' },
    Starting = { fg = '#757755' },
    ServerReady = { fg = '#117711' },
    TCPStart = { fg = '#ff8833' },
    TCPReady = { fg = '#3388ff' },
    RStarting = { fg = '#ff8833' },
    Ready = { fg = '#3388ff' },
  }, { prefix = 'RStatus', default = true })
  local rstt = {
    { '-', 'RStatusInactive' }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
    { 'S', 'RStatusStarting' }, -- 2: nclientserver started, but not ready yet.
    { 'S', 'RStatusServerReady' }, -- 3: nclientserver is ready.
    { 'S', 'RStatusTCPStart' }, -- 4: nclientserver started the TCP server
    { 'S', 'RStatusTCPReady' }, -- 5: TCP server is ready
    { 'R', 'RStatusRStarting' }, -- 6: R started, but nvimcom was not loaded yet.
    { '󰟔 ', 'RStatusReady' }, -- 7: nvimcom is loaded.
  }

  return {
    function() return rstt[vim.g.R_Nvim_status][1] end,
    color = function() return rstt[vim.g.R_Nvim_status][2] end,
    cond = function()
      if not vim.tbl_contains({ 'r', 'rmd', 'quarto' }, vim.bo.filetype) then
        return false
      end
      return vim.g.R_Nvim_status and vim.g.R_Nvim_status > 0
    end,
  }
end

return M
