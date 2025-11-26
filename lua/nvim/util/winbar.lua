---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

local M = {}

M.a = function(opts)
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

local ft_map = {
  dirvish = {
    a = [[%{%v:lua.nv.icons.directory(b:dirvish._dir)..' '..fnamemodify(b:dirvish._dir, ':~')%}]],
    b = [[%{%v:lua.nv.lsp.dirvish.status()%}]],
    c = [[ %{join(map if opts.ft == '(argv(), "fnamemodify(v:val, ':t')"), ', ')} ]],
  },
}

M.lualine_extensions = vim
  .iter(pairs(ft_map))
  :map(function(ft, sec)
    return {
      winbar = {
        lualine_a = { sec.a },
        lualine_b = { sec.b },
        lualine_c = { sec.c },
        lualine_z = sec.z and { sec.z } or nil,
      },
      filetypes = { ft },
    }
  end)
  :totable()

-- local stlescape = function(s) return s:gsub('%%', '%%%%'):gsub('\n', ' ') end
---@param opts? vim.api.keyset.eval_statusline
M.debug = function(opts)
  opts = opts or {}
  opts.use_winbar = true
  -- TODO:
  return vim.api.nvim_eval_statusline(nv.winbar(opts))
end

return M
