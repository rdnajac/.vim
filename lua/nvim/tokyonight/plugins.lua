return {
  -- ["ale"]                     = "ale",
  ["blink.cmp"]               = "blink",
  -- ["copilot.lua"]             = "copilot",
  -- ["flash.nvim"]              = "flash",
  -- ["fzf-lua"]                 = "fzf",
  ["mini.animate"]            = "mini_animate",
  ["mini.diff"]               = "mini_diff",
  -- ["mini.hipatterns"]         = "mini_hipatterns",
  -- ["mini.icons"]              = "mini_icons",
  ["nvim-treesitter-context"] = "treesitter-context",
  -- ["octo.nvim"]               = "octo",
  ["render-markdown.nvim"]    = "render-markdown",
  -- ["sidekick.nvim"]           = "sidekick",
  ["snacks.nvim"]             = "snacks",
  -- ["trouble.nvim"]            = "trouble",
  -- ["vimwiki"]                 = "vimwiki",
  ["which-key.nvim"]          = "which-key",
}
-- return vim
--   .iter(require('tokyonight.groups').plugins)
--   :fold({ all = false }, function(acc, name, plugin)
--     if
--       vim.uv.fs_stat(vim.env.PACKDIR .. '/' .. name)
--       or (
--         vim.startswith(name, 'mini')
--         and vim.tbl_contains({
--           'diff',
--           -- 'hipatterns',
--           -- 'icons',
--         }, name:sub(6))
--       )
--     then
--       return rawset(acc, plugin, true)
--     else
--       return acc
--     end
--   end)
