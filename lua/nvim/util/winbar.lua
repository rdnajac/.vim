local M = {}

-- sanitize `%` for the statuslines
-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end

M.debug = function(str, opts)
  return vim.api.nvim_eval_statusline(str, opts)
end

local function section(sec, parts)
  local hl = '%#Chromatophore_' .. sec .. '#'
  return hl .. table.concat(vim.islist(parts) and parts or { parts })
end

function M.render(a, b, c)
  local sep = nv.icons.separators.component.rounded.left
  local sec_a = a and (section('a', a) .. '%#Chromatophore_ab#' .. sep) or ''
  local sec_b = b and (section('b', b) .. '%#Chromatophore_bc#' .. sep) or ''
  local sec_c = section('c', c)
  return sec_a .. sec_b .. sec_c
  -- return table.concat({ sec_a, sec_b, sec_c })
end

local function is_active_win()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

---@param path string|nil
local function buffer_components(path)
  local bt = vim.bo.buftype
  if bt == 'help' then
    path = '%h ' .. nv.icons.separators.section.angle.left .. ' %t'
  elseif bt ~= '' then
    local ft = vim.bo.filetype
    if ft == 'oil' then
      path = require('oil').get_current_dir()
    elseif ft == 'nvim-pack' then
      path = vim.g.plug_home
    elseif bt == 'terminal' then
      path = vim.fn.getcwd()
    end
    path = path and vim.fn.fnamemodify(path, ':~') or ''
  else
    path = is_active_win() and '%t' or '%f' or ''
  end

  return (' %s %s%s%s'):format(
    path,
    nv.icons.filetype[vim.bo.filetype],
    vim.bo.modified and ' ' or '',
    vim.bo.readonly and ' ' or ''
  )
end

  -- stylua: ignore
local bt_map = {
  nofile   =  '[NOFILE]' ,
  nowrite  =  '[NOWRITE]',
  prompt   =  '[PROMPT]' ,
  quickfix =  '%q'       ,
}

M.winbar = function()
  local ft = vim.bo.filetype
  if ft == 'snacks_dashboard' then
    return '' -- TODO: put startuptime here?
  end

  local bt = vim.bo.buftype
  if vim.tbl_contains(vim.tbl_keys(bt_map), bt) then
    return bt_map[bt]
  end
  if not is_active_win() then
    return section('c', buffer_components())
  end
  local a = buffer_components()
  local b = nv.status()
  local c = nv.lsp.docsymbols()
  return M.render(a, b, c)
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
