---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

local M = {}

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end
-- M.debug = function(str, opts) return vim.api.nvim_eval_statusline(str, opts) end

local function hl(subscript)
  return '%#Chromatophore_' .. subscript .. '#'
end

function M.render(a, b, c)
  local sep = nv.icons.separators.component.rounded.left
  local sec_a = a and string.format('%s%s%s%s', hl('a'), a, hl('ab'), sep) or ''
  local sec_b = b and string.format('%s%s%s%s', hl('b'), b, hl('bc'), sep) or ''
  local sec_c = string.format('%s%s', hl('c'), c)
  return sec_a .. sec_b .. sec_c
end

local function is_active_win()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local path_from_ft = {
  oil = require('oil').get_current_dir,
  ['nvim-pack'] = vim.g.plug_home,
}

---@param active boolean
---@param bt string
---@param ft string
local function buffer_components(active, bt, ft)
  local path
  ---@type (''|'acwrite'|'help'|'nowrite'|'terminal') | 'nofile'

  if active then
    path = '%h' .. (ft == 'help' and (' ' .. nv.icons.separators.section.angle.left .. ' ') or '') .. '%t'
  else
    path = '%f'
  end

    if ft == 'oil' then
      path = require('oil').get_current_dir()
    elseif ft == 'nvim-pack' then
      path = vim.g.plug_home
    end

  if bt ~= '' and bt ~= 'help' then
    path = vim.fn.fnamemodify(path or vim.fn.getcwd(), ':~')
  end

  return (' %s %s%s%s'):format(
    path,
    active and bt ~= 'nofile' and nv.icons.filetype[ft] or '',
    vim.bo.modified and ' ' or '',
    vim.bo.readonly and ' ' or ''
    -- TODO: add ff, fenc, etc
  )
end

M.winbar = function()
  local bt = vim.bo.buftype
  if vim.tbl_contains({ 'quickfix', 'prompt' }, bt) then
    return ''
  end

  ---@alias buftype_1 ''|'acwrite'|'help'|'nofile'|'nowrite'|'terminal'

  local active = is_active_win()
  local ft = vim.bo.filetype
  local bufcomp = buffer_components(active, bt, ft)

  if not active or bt == 'nofile' then
    return M.render(nil, nil, bufcomp)
  end

  ---@alias buftype_2a ''|'acwrite'|'help'|'nowrite'|'terminal'
  local a = bufcomp
  local b = nv.status()
  local c = nv.lsp.docsymbols()
  return M.render(a, b, c)
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
