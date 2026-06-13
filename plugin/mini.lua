for k, opts in pairs({
  -- splitjoin = { mappings = { toggle = 'g~', split = 'gS', join = 'gJ' }, },
  -- TODO:  implement native argument textobject... aa 'around argument'
  -- ai = { mappings = { around_next = 'aN', inside_next = 'iN', around_last = 'aL', inside_last = 'iL', } },
  align = function()
    vim.cmd('xmap ga gA') -- preserve normal `ga` for `vim-characterize`
    return { mappings = { start = 'gA', start_with_preview = 'g|' } }
  end,

  icons = function()
    -- HACK: Override get to do wildcard matching
    vim.schedule(nv.ui.icons.mini_override)

    local function minify(v)
      local glyph = type(v) == 'table' and v[1] or v
      local color = type(v) == 'table' and v[2] or 'Green'
      return { glyph = glyph, hl = 'MiniIcons' .. color }
    end

    -- local opts = vim.tblrequire('nvim.ui.icons').mini
    -- opts.use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end
    -- return opts

    return vim.iter(require('nvim.ui.icons').mini):fold({
      use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end,
    }, function(acc, k, v) return rawset(acc, k, vim.tbl_map(minify, v)) end)
  end,

  hipatterns = function()
    local highlighters = require('nvim.ui.highlighters')
    highlighters.hex_color = require('mini.hipatterns').gen_highlighter.hex_color()
    return { highlighters = highlighters }
  end,
}) do
  require('mini.' .. k).setup(opts())
end
