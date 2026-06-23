for k, opts in pairs({
  ai = {
    mappings = { around_next = 'aN', inside_next = 'iN', around_last = 'aL', inside_last = 'iL' },
  },
  align = function()
    vim.cmd('xmap ga gA') -- preserve normal `ga` for `vim-characterize`
    return { mappings = { start = 'gA', start_with_preview = 'g|' } }
  end,
  hipatterns = function()
    local opts = { highlighters = nv.ui.highlighters }
    opts.highlighters.hex_color = require('mini.hipatterns').gen_highlighter.hex_color()
    return opts
  end,
  icons = function()
    vim.schedule(nv.ui.icons.mini_override) -- HACK: Override `get` to do wildcard matching
    local opts = {
      use_file_extension = function(ext, _)
        return ext:sub(-3) ~= 'scm'
      end,
    }
    local function minify(v)
      local glyph = type(v) == 'table' and v[1] or v
      local color = type(v) == 'table' and v[2] or 'Green'
      return { glyph = glyph, hl = 'MiniIcons' .. color }
    end
    return vim.iter(nv.ui.icons.mini):fold({ opts }, function(acc, k, v)
      return rawset(acc, k, vim.tbl_map(minify, v))
    end)
  end,
  splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' } },
}) do
  require('mini.' .. k).setup(type(opts) == 'table' and opts or opts())
end
-- vim: fdl=2
