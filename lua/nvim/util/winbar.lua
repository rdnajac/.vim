---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'
-- TODO: migrate to lualine?

local M = {
  a = function(opts)
    local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    local win = opts.win or vim.api.nvim_get_current_win()
    local bt = opts.bt or vim.bo[bufnr].buftype
    local ft = opts.ft or vim.bo[bufnr].filetype
    local path

    if ft == 'dirvish' then
      path = vim.b[bufnr].dirvish._dir
      return nv.icons.directory[path] .. ' ' .. vim.fn.fnamemodify(path, ':~')
    end

    if bt == '' then
      local active = opts.active or (win == tonumber(vim.g.actual_curwin))
      path = active and '%t' or '%f'
    elseif bt == 'help' then
      path = '%t'
    else
      local maybe_path = ''
      if bt == 'acwrite' and ft == 'nvim-pack' then
        maybe_path = vim.g.plug_home
      elseif bt == 'terminal' then
        maybe_path = vim.b[bufnr].osc7_dir
        -- or vim.env.PWD -- not updated on dir change?
      end
      path = vim.fn.fnamemodify(maybe_path or vim.fn.getcwd(), ':~')
    end

    return table.concat({
      '%h%w%q ', -- help/preview/quickfix
      path,
      "%{% &readonly ? ' ' : '%M' %}",
      "%{% &busy     ? '◐ ' : ''   %}",
      [[%{% &ff !=# 'unix'  ? ' ff=' . &ff : ''  %}]],
      [[%{% &fenc !=# 'utf-8'  ? ' fenc=' . &fenc : ''  %}]],
    })
  end,

  b = function()
    ---@type fun():string[]|nv.status.Component
    local parts = {
      function()
        if vim.bo.buftype == 'terminal' then
          return "%{% &buftype == 'terminal' ? ' %{&channel}' : '' %}"
        end
        return "%{% &buflisted ? '%n' : '󱪟 ' %}" .. "%{% &bufhidden == '' ? '' : '󰘓 ' %}"
      end,
      nv.status.treesitter,
      nv.status.lsp,
      nv.status.blink,
      require('nvim.plugins.r').status,
    }
    return vim
      .iter(parts)
      :map(function(p)
        local value
        if type(p) == 'string' then
          value = p
        elseif type(p) == 'function' then
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
        local ret
        if type(value) == 'table' then
          ret = table.concat(value, ' ')
        elseif type(value) == 'string' then
          ret = value
        end
        if ret ~= nil then
          -- FIXME:
          -- if type(p) == 'table' and p.color ~= nil then
          --   local color = vim.is_callable(p.color) and p.color() or p.color
          --   ret = string.format('%%#%s#%s%%#Chromatophore_b#', color, ret)
          -- end
          return ret
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
    -- return '%<' .. table.concat(require('nvim.util.lsp.docsymbols')(), nv.icons.sep.item.right)
  end,
}

function M.render(a, b, c)
  -- stylua: ignore start
  local function hl(s) return '%#Chromatophore_' .. s .. '#' end
  local function sec(s, str) return hl(s) .. str end
  --stylua: ignore end
  local sep = nv.icons.sep.component.rounded.left
  local sec_a = a and sec('a', a) or nil
  local sec_b = b and sec('ab', sep .. ' ') .. sec('b', b) .. sec('bc', sep) or sec('c', sep)
  local sec_c = c and sec('c', c) or ''
  -- return string.format('%s%s%s', sec_a, sec_b, sec_c)
  local ret = { sec_a, sec_b, sec_c }
  return table.concat(ret)
end

M.winbar = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  opts.win = opts.win or vim.api.nvim_get_current_win()
  opts.active = opts.active or (opts.win == tonumber(vim.g.actual_curwin))
  opts.bt = vim.bo[opts.bufnr].buftype
  opts.ft = vim.bo[opts.bufnr].filetype

  -- TODO: since only a needs opts, move things around
  local winbar = M.a(opts)

  -- TODO: return early if inactive or help
  if opts.ft == 'dirvish' then
    local clients = vim.lsp.get_clients({ bufnr = opts.bufnr, name = 'dirvish' })
    local b = #clients > 0 and '%{%v:lua.nv.status.lsp()%}' or ''
    local c = [[%{join(map(argv(), "fnamemodify(v:val, ':t')"), ' ')}]]
    return M.render(winbar, b, c)
  end
  if opts.active and opts.bt ~= 'help' then
    return M.render(winbar, M.b(), M.c())
  end
  return M.render(nv.icons.filetype(opts.ft), winbar, '')
end

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end
---@param opts? vim.api.keyset.eval_statusline
M.debug = function(opts)
  opts = opts or {}
  opts.use_winbar = true
  return vim.api.nvim_eval_statusline(nv.winbar(opts))
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
