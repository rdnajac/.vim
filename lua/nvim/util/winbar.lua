---@class component
---@field [1] fun():string[]|string[]
---@field cond? fun():boolean
---@field color? any

---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'
-- TODO: use a buftype map. IT WORKS

local M = {}

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end
---@param opts? vim.api.keyset.eval_statusline
M.debug = function(opts)
  opts = opts or {}
  opts.use_winbar = true
  return vim.api.nvim_eval_statusline(nv.winbar(0, 0, true), opts)
end

function M.render(a, b, c)
  -- stylua: ignore start
  local function hl(s) return '%#Chromatophore_' .. s .. '#' end
  local function sec(s, str) return hl(s) .. str end
  --stylua: ignore end
  local sep = nv.icons.separators.component.rounded.left
  local sec_a = a and sec('a', a) or ''
  local sec_b = b and sec('ab', sep) .. sec('b', b) .. sec('bc', sep) or sec('c', sep)
  -- return sec_a .. sec_b .. sec('c', c)
  return string.format('%s%s%s', sec_a, sec_b, sec('c', c))
end

local buffer_status = function(bt)
  bt = bt or vim.bo.buftype
  if bt ~= '' then
    if bt == 'terminal' then
      return nv.status.term()
    end
    return nil -- otherwise
  end

  local parts = {
    -- TODO: add bufhidden/buflisted etc
    ' bufnr = %n',
    -- 'TS ' ..
    table.concat(nv.status.treesitter(), ' '),
    -- 'LSP ' ..
    table.concat(nv.status.lsp(), ' '),
    vim.fn.mode():sub(1, 1) == 'i' and table.concat(nv.status.blink(), ' ') or nil,
  }

  return table.concat(parts, '  ')
end

---@param bufnr? number
---@param ft? string
---@return string
local stl_icons = function(bufnr, ft)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  ft = ft or vim.bo[bufnr].filetype
  return table.concat({
    -- vim.bo.modifiable == false and '󱙄 ' or vim.bo.modified and '󰳼 ' or '',
    vim.bo[bufnr].modified and '󰳼 ' or '',
    vim.bo[bufnr].readonly and ' ' or '',
    vim.bo[bufnr].busy > 0 and '◐ ' or '',
    -- TODO: add ff, fenc, etc
    nv.icons.filetype[ft],
  })
end

local buffer_path = function(active, bt, ft)
  local path = { '%h%w%q' }
  if bt == '' then
    table.insert(path, active and '%t' or '%f')
  elseif bt == 'acwrite' then
    local ins
    if ft == 'nvim-pack' then
      ins = vim.g.plug_home
    elseif ft == 'oil' then
      ins = require('oil').get_current_dir()
    end
    table.insert(path, vim.fn.fnamemodify(ins or vim.fn.getcwd(), ':~'))
  end
  table.insert(path, stl_icons(nil, ft))
  return table.concat(path, ' ')
end

-- nofile: snacks_
-- if bt == 'nofile' then return '' end
local winbar_by_bt = {
  [''] = function(ft) end,
  acwrite = function(ft) end,
  help = function(ft) end,
  nofile = function(ft) end,
  nowrite = function(ft) end,
  quickfix = function(ft) end,
  terminal = function(ft) end,
  prompt = function(ft) end,
}

---@param bufnr? number
local buffer_details = function(bufnr)
  local diagnostic = nv.status.diagnostic(bufnr)
  if diagnostic ~= '' then
    return diagnostic
  end
  return '%<' .. nv.lsp.docsymbols()
end

M.winbar = function(bufnr, win, active)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  win = win or vim.api.nvim_get_current_win()
  active = active or (win == tonumber(vim.g.actual_curwin))

  local bt = vim.bo[bufnr].buftype
  local ft = vim.bo[bufnr].filetype

  local a = buffer_path(active, bt, ft)
  if not active then
    return a
  end
  local b = buffer_status(bt)
  local c = buffer_details(bufnr)
  return M.render(a, b, c)
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
