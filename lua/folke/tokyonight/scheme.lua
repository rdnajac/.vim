local M = {}

--- Generate Vim colorscheme highlight commands from highlight groups
---@param groups tokyonight.Highlights Highlight groups table
---@return string[] lines Array of Vim highlight commands
function M.gen(groups)
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

  local function build_props(hl)
    local props = vim
      .iter(vim.spairs(hl))
      :filter(function(k)
        print(k)
        return mapping[k]
      end)
      :map(function(k, v)
        return ('%s=%s'):format(mapping[k], v)
      end)
      :totable()

    local gui = vim
      .iter(vim.spairs(hl))
      :filter(function(k, v)
        return vim.tbl_contains(attrs, k) and v
      end)
      :map(function(k)
        return k
      end)
      :totable()

    if #gui > 0 then
      table.insert(props, ('gui=%s'):format(table.concat(gui, ',')))
    end

    if not hl.bg then
      table.insert(props, 'guibg=NONE')
    end

    return props
  end

  -- build highlight definitions and links
  local links = vim
    .iter(vim.spairs(groups))
    :filter(function(name)
      return not vim.startswith(name, '@')
    end)
    :map(function(name, hl)
      if type(hl) == 'string' and not vim.startswith(hl, '@') then
        hl = { link = hl }
      end

      if hl.link then
        return groups[hl.link] and ('hi! link %s %s'):format(name, hl.link) or nil
      elseif type(hl) == 'table' then
        local props = build_props(hl)
        if #props > 0 then
          table.insert(lines, ('hi %s %s'):format(name, table.concat(props, ' ')))
        else
          vim.schedule(function()
            vim.notify(
              ('tokyonight: invalid highlight group: %s'):format(name),
              vim.log.levels.WARN
            )
          end)
        end
      end
    end)
    :totable()

  -- add links at the end to ensure the original groups are defined
  return vim.list_extend(lines, vim.list.unique(links))
end

--- Write content to a file in the colors directory
---@param filename string The name of the file (without directory path)
---@param content string|string[] Content to write (string or array of lines)
local function write(filename, content)
  local f = require('nvim.util.file')
  local filepath = vim.fs.joinpath(vim.fn.stdpath('config'), 'colors', filename)
  if type(content) == 'table' then
    f.write_lines(filepath, content)
  else
    f.write(filepath, content)
  end
end

M.tokyonight_extra_lua = function(colors, groups)
  return require('tokyonight.extra.lua').generate(colors, groups)
end

M.tokyonight_extra_vim = function(colors, groups, opts)
  local colors, groups, opts = require('tokyonight.theme').setup(opts)
  return require('tokyonight.extra.vim').generate()
end

--- Write executed highlights from nvim.util.exec to file
--- Converts highlight definitions and links to Vim highlight commands
--- Output file: `tokyonight_highlight.vim`
function M.exec()
  local exec = require('nvim.util.exec')
  local highlight_lines = vim
    .iter(exec.highlight)
    :map(function(hl)
      if hl.link then
        return ('hi! link %s %s'):format(hl.group, hl.link)
      elseif hl.def then
        local parts = vim
          .iter(pairs(hl.def))
          :map(function(k, v)
            return ('%s=%s'):format(k, v)
          end)
          :totable()
        return ('hi %s %s'):format(hl.group, table.concat(parts, ' '))
      end
    end)
    :totable()
  write_to_colors_file('tokyonight_highlight.vim', highlight_lines)
end

return M
