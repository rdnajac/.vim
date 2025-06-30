-- takes a vimscript statusline and applies the colorscheme so its compatible with tmux

-- %#Chromatophore_a# 󱉭 chezmoi/%#Chromatophore_ab#🭛%#Chromatophore_b#dot_config/tmux/bin/executable_nvim-tmux.sh
-- becomes:
local M = function(line)
  local out = {}
  local last = {}

  for hl, text in line:gmatch('%%#(.-)#([^%%]*)') do
    local info = vim.api.nvim_get_hl(0, { name = hl, link = false })
    local fg = info.fg and string.format('#%06x', info.fg) or nil
    local bg = info.bg and string.format('#%06x', info.bg) or nil
    local fmt = {
      fg = fg ~= last.fg and fg or nil,
      bg = bg ~= last.bg and bg or nil,
      bold = info.bold and not last.bold and true or nil,
      underline = info.underline and not last.underline and true or nil,
      italic = info.italic and not last.italic and true or nil,
    }

    local attrs = {}
    for k, v in pairs(fmt) do
      if k == 'bold' or k == 'underline' or k == 'italic' then
        attrs[#attrs + 1] = v and k or ('no' .. k)
      else
        attrs[#attrs + 1] = v and (k .. '=' .. v)
      end
    end

    if #attrs > 0 then
      table.insert(out, '#[' .. table.concat(attrs, ',') .. ']')
      last = {
        fg = fg,
        bg = bg,
        bold = info.bold,
        underline = info.underline,
        italic = info.italic,
      }
    end

    if text ~= '' then
      table.insert(out, text)
    end
  end

  return table.concat(out)
end

return M
