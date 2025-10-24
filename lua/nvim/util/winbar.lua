---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'
-- TODO: use a buftype map. IT WORKS

---@param bufnr? number
---@param ft? string
---@return string
local stl_icons = function(bufnr, ft)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  ft = ft or vim.bo[bufnr].filetype
  return table.concat({
    -- vim.bo.modifiable == false and '󱙄 ' or vim.bo.modified and '󰳼 ' or '',
    vim.bo[bufnr].readonly and ' ' or '',
    vim.bo[bufnr].busy > 0 and '◐ ' or '',
    -- TODO: add ff, fenc, etc
    nv.icons.filetype[ft],
  })
end

local M = {
  a = function(active, bt, ft)
    local path = { '%h%w%q' }
    if bt == '' then
      table.insert(path, active and '%t' or '%f')
    elseif bt == 'terminal' then
      table.insert(
        path,
        vim.fn.fnamemodify(vim.b[vim.api.nvim_get_current_buf()].osc7_dir or vim.fn.getcwd(), ':~')
      )
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
  end,

  b = function()
    ---@type fun():string[]|nv.status.Component
    local parts = {
      nv.status.buffer,
      nv.status.treesitter,
      nv.status.lsp,
      nv.status.blink,
    }
    return vim
      .iter(parts)
      :map(function(p)
        local value
        if type(p) == 'function' then
          value = p()
        elseif type(p) == 'table' then
          if p.cond == nil or p.cond() then
            local f = p[1]
            if type(f) == 'function' then
              value = f()
            elseif type(f) == 'table' then
              value = f
            elseif type(f) == 'string' then
              value = { f }
            end
          end
        end
        if type(value) == 'table' then
          return table.concat(value, ' ')
        elseif type(value) == 'string' then
          return value
        end
        return nil
      end)
      :filter(function(v)
        return v ~= nil and v ~= ''
      end)
      :join('  ')
  end,

  c = function()
    if nv.status.diagnostic.cond(vim.api.nvim_get_current_buf()) then
      return nv.status.diagnostic[1]()
    end
    return '%<' .. table.concat(require('nvim.util.lsp.docsymbols')(), nv.icons.sep.item.right)
  end,
}

function M.render(a, b, c)
  -- stylua: ignore start
  local function hl(s) return '%#Chromatophore_' .. s .. '#' end
  local function sec(s, str) return hl(s) .. str end
  --stylua: ignore end
  local sep = nv.icons.sep.component.rounded.left
  local sec_a = a and sec('a', a) or ''
  local sec_b = b and sec('ab', sep .. ' ') .. sec('b', b) .. sec('bc', sep) or sec('c', sep)
  -- return sec_a .. sec_b .. sec('c', c)
  return string.format('%s%s%s', sec_a, sec_b, sec('c', c))
end

local winbar_by_bt = {
  [''] = function(ft) end,
  acwrite = {
    oil = require('oil').get_current_dir,
    ['nvim-pack'] = function()
      return vim.g.plug_home
    end,
  },
  help = function(ft) end,
  nofile = function(ft) end,
  nowrite = function(ft) end,
  quickfix = function(ft) end,
  terminal = function(ft) end,
  prompt = function(ft) end,
}

M.winbar = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  opts.win = opts.win or vim.api.nvim_get_current_win()
  opts.active = opts.active or (opts.win == tonumber(vim.g.actual_curwin))
  opts.bt = vim.bo[opts.bufnr].buftype
  opts.ft = vim.bo[opts.bufnr].filetype

  local winbar = M.a(opts)

  return opts.active and M.render(winbar, M.b(), M.c()) or winbar
end

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end
---@param opts? vim.api.keyset.eval_statusline
M.debug = function(opts)
  opts = opts or {}
  opts.use_winbar = true
  return vim.api.nvim_eval_statusline(nv.winbar(0, 0, true), opts)
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
