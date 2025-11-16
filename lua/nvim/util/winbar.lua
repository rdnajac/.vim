---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'
-- TODO: migrate to lualine?

local M = {
  a = function(opts)
    local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    local win = opts.win or vim.api.nvim_get_current_win()
    local bt = opts.bt or vim.bo[bufnr].buftype
    local ft = opts.ft or vim.bo[bufnr].filetype
    local path

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
      [[%{% &readonly ? ' ' : '%M' %}]],
      [[%{% &busy     ? '◐ ' : ''   %}]],
      [[%{% &ff !=# 'unix'  ? ' ff=' . &ff : ''  %}]],
      [[%{% &fenc !=# 'utf-8' && &fenc !=# ''  ? ' fenc=' . &fenc : ''  %}]],
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
  local function sec(s, str)
    return string.format('%%#Chromatophore_%s#%s', s, str)
  end
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

  local a, b, c

  if opts.ft == 'dirvish' then
    a = [[%{%v:lua.nv.icons.directory(b:dirvish._dir)..' '..fnamemodify(b:dirvish._dir, ':~')%}]]
    b = [[%{%v:lua.nv.lsp.dirvish.status()%}]]
    c = [[ %{join(map(argv(), "fnamemodify(v:val, ':t')"), ', ')} ]]
  elseif opts.active and opts.bt ~= 'help' then
    a = M.a(opts)
    b = M.b()
    c = M.c()
  else
    a = nv.icons.filetype(opts.ft)
    b = M.a(opts)
    c = ''
  end

  return M.render(a, b, c)
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
