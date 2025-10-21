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
  local sec_a = section('a', a) .. '%#Chromatophore_ab#'
  local sec_b = section('b', b) .. '%#Chromatophore_bc#'
  local sec_c = section('c', c)
  local sep = nv.icons.separators.component.rounded.left
  return table.concat({ sec_a, sec_b, sec_c }, sep)
end

---@param path string
local function buffer_components(path)
  return (' %s %s%s%s'):format(
  -- return {
    path,
    nv.icons.filetype[vim.bo.filetype],
    vim.bo.modified and ' ' or '',
    vim.bo.readonly and ' ' or ''
  )
end

local function is_active()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local buf_map = {
  [''] = function()
    return buffer_components(is_active() and '%t' or '%f')
  end,
  acwrite = function(ft)
    local path
    if ft == 'oil' then
      path = require('oil').get_current_dir()
    elseif ft == 'nvim-pack' then
      path = vim.g.plug_home
    end
    if path then
      return buffer_components(vim.fn.fnamemodify(path, ':~'))
    end
    return ''
  end,
  -- stylua: ignore start
  help = function() return { '󰋖 ', '%f' } end,
  nofile = function() return { '[NOFILE]' } end,
  nowrite = function() return { '[NOWRITE]' } end,
  prompt = function() return { '[PROMPT]' } end,
  quickfix = function() return { '%q' } end,
  --stylua: ignore end
  terminal = function(ft)
    return buffer_components(vim.fn.fnamemodify(vim.fn.getcwd(), ':~'))
  end,
}

M.winbar = function()
  local ft = vim.bo.filetype
  if ft == 'snacks_dashboard' then
    return '' -- TODO: put startuptime here?
  end

  local bt = vim.bo.buftype
  if bt == '' or bt == 'acwrite' or bt == 'terminal' then
    if not is_active() then
      return section('c', buf_map[bt](ft))
    end
    -- local a = buf_map[bt](ft)
    local a = buf_map[bt](ft)
    local b = nv.status()
    local c = nv.lsp.docsymbols()
    return M.render(a, b, c)
  end
end

function M.setup()
  nv.winbar = M.winbar
  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
