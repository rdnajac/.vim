-- filter only modules under config
-- TODO: use this to make bookmarks for submodules under nvim not using vim.loader
local mods = vim.tbl_filter(function(m)
  return m.modpath:find(vim.fn.stdpath('config'), 1, true) == 1
end, vim.loader.find('*', { all = true }))

local seen = {}

for _, m in ipairs(mods) do
  local char_idx = m.modname:sub(1, 1)

  -- prefer init.lua if it exists
  local init_file = vim.fs.joinpath(m.modpath, 'init.lua')
  local file_to_edit = vim.fn.filereadable(init_file) == 1 and init_file or m.modpath

  if not vim.tbl_contains(seen, char_idx) then
    seen[#seen + 1] = char_idx
    vim.keymap.set('n', '<Bslash>' .. char_idx, function()
      vim.cmd.edit(file_to_edit)
    end, { desc = 'Edit ' .. m.modname })
  end
end
