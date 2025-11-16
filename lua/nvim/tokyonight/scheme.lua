local M = {}

---@return string[]
function M.generate_vim_scheme(opts)
  opts = opts or {}
  opts.plugins = { all = false } -- disable plugins for scheme generation
  local _, groups, _ = require('tokyonight').load(opts)

  local lines = {
    'hi clear',
    "let g:colors_name = 'tokyonight'",
  }

  local mapping = { fg = 'guifg', bg = 'guibg', sp = 'guisp' }
  local attrs = {
    'bold',
    'underline',
    'undercurl',
    'italic',
    'strikethrough',
    'underdouble',
    'underdotted',
    'underdashed',
    'inverse',
    'standout',
    'nocombine',
    'altfont',
  }

  local function to_table(t, fn)
    local ret = {}
    for k, v in vim.spairs(t) do
      local result = fn(k, v)
      if result ~= nil then
        ret[#ret + 1] = result
      end
    end
    return ret
  end

  -- build highlight definitions and links
  local links = {}
  for name, hl in vim.spairs(groups) do
    if not vim.startswith(name, '@') then -- skip treesitter/semantic tokens
      if type(hl) == 'string' and not vim.startswith(hl, '@') then
        hl = { link = hl }
      end

      if hl.link then
        if groups[hl.link] then
          links[#links + 1] = ('hi! link %s %s'):format(name, hl.link)
        end
      elseif type(hl) == 'table' then
        local props = to_table(hl, function(k, v)
          if mapping[k] then
            return ('%s=%s'):format(mapping[k], v)
          end
        end)

        local gui = to_table(hl, function(k, v)
          if vim.tbl_contains(attrs, k) and v then
            return k
          end
        end)

        if #gui > 0 then
          props[#props + 1] = ('gui=%s'):format(table.concat(gui, ','))
        end

        if not hl.bg then
          props[#props + 1] = 'guibg=NONE'
        end

        if #props > 0 then
          lines[#lines + 1] = ('hi %s %s'):format(name, table.concat(props, ' '))
        else
          vim.schedule(function()
            vim.notify(
              ('tokyonight: invalid highlight group: %s'):format(name),
              vim.log.levels.WARN
            )
          end)
        end
      end
    end
  end

  -- add links at the end to ensure the original groups are defined
  return vim.list_extend(lines, vim.list.unique(links))
end

M.write_vim_scheme = function()
  local write_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'colors')
  local fname = vim.fs.joinpath(write_dir, 'tokyomidnight.vim')
  print('Writing ' .. fname)
  nv.file.write_lines(fname, M.generate_vim_scheme())
end

return M
