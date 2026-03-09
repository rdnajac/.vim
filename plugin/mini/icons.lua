local opts = {}

-- local icons = require('nvim.ui.icons').mini
for icon, v in pairs(icons or {}) do
  opts[icon] = vim.tbl_map(
    function(pair) return { glyph = pair[1], hl = 'MiniIcons' .. pair[2] } end,
    v
  )
end

opts.use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end

require('mini.icons').setup(opts)

local directories_override = {
  ['vim%-.*'] = { '', 'Green' },
  ['lazy.*%.nvim'] = { '󰒲', 'Blue' },
}

-- -- HACK: Override to use wildcard matching for directories
-- vim.schedule(function()
--   local original_get = MiniIcons.get
--   ---@diagnostic disable-next-line: duplicate-set-field
--   MiniIcons.get = function(category, name)
--     if category == 'directory' then
--       local dir = vim.fs.basename(name)
--       for pattern, pair in pairs(directories_override) do
--         -- add anchors to pattern for exact match
--         if dir:match('^' .. pattern .. '$') then
--           return pair[1], 'MiniIcons' .. pair[2]
--         end
--       end
--       -- TODO:
--       -- elseif category == 'file' then
--       -- name = name:gsub('dot_', '.')
--     else
--       return original_get(category, name:gsub('dot_', '.'))
--     end
--   end
-- end)
