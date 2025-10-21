local M = {
  a = function(parts)
    local ret = {}
    table.insert(ret, '%#Chromatophore_a#')
    table.insert(ret, nv.icons.filetype[vim.bo.filetype])
    vim.list_extend(ret, vim.islist(parts) and parts or { parts })
    return table.concat(ret, ' ') .. '%#Chromatophore_b#'
  end,
  b = function(s)
    return '%#Chromatophore_b#' .. s .. '%#Chromatophore_bc#'
  end,
  c = function(s)
    return '%#Chromatophore_c#' .. s
  end,
  inactive = function() end,
}

function M.render(a, b, c)
  return table.concat({ a or '', b or '', c or '' }, nv.icons.separators.component.rounded.left)
end

local function is_active()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

---@param path string
---@return string
local function buffer_component(path)
  return ('%s %s%s'):format(
    path,
    vim.bo.modified and ' ' or '',
    vim.bo.readonly and ' ' or ''
  )
end

local map = {
  [''] = function()
    if not is_active() then
      return M.c(buffer_component(vim.fn.expand('%:~:.')))
    end
    local a = M.a(buffer_component('%t'))
    local b = M.b(nv.status())
    local c = M.c(nv.lsp.docsymbols.get())
    return M.render(a, b, c)
  end,
  acwrite = function()
    -- local a, b, c
    local path
    local ft = vim.bo.filetype
    if ft == 'oil' then
      path = require('oil').get_current_dir()
    elseif ft == 'nvim-pack' then
      path = vim.g.plug_home
    end
    if path then
      return M.a(vim.fn.fnamemodify(path, ':~'))
    end
  end,
  -- stylua: ignore start
  help = function() return { '󰋖 ', '%f' } end,
  nofile = function() return { '[NOFILE]' } end,
  nowrite = function() return { '[NOWRITE]' } end,
  prompt = function() return { '[PROMPT]' } end,
  quickfix = function() return { '%q' } end,
  --stylua: ignore end
  terminal = function()
    return M.render(
      M.a(vim.fn.fnamemodify(vim.fn.getcwd(), ':~')),
      M.b(
        (vim.g.ooze_channel ~= nil and vim.g.ooze_channel == vim.bo.channel) and ' '
          or ' ' .. vim.bo.channel
      )
    )
  end,
}

M.winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return '' -- TODO: put startuptime here?
  end
  return map[vim.bo.buftype]()
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
