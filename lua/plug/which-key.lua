local M = { 'folke/which-key.nvim' }

---@class wk.Opts
M.opts = {
  preset = 'helix',
  keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
  show_help = false,
  sort = { 'order', 'alphanum', 'case', 'mod' },
  spec = {
    {
      {
        mode = { 'n', 'v' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'z', group = 'fold' },
      },
      mode = { 'n' },
      -- {
      --   '<leader>b',
      --   group = 'buffer',
      --   expand = function()
      --     return require('which-key.extras').expand.buf()
      --   end,
      -- },
      -- {
      --   '<c-w>',
      --   group = 'windows',
      --   expand = function()
      --     return require('which-key.extras').expand.win()
      --   end,
      -- },

      -- groups
      { 'co', group = 'comment below' },
      { 'cO', group = 'comment above' },
      { '<leader>dp', group = 'profiler' },
      { '<localleader>l', group = 'vimtex' },

      -- descriptions
      { 'gx', desc = 'Open with system app' },
    },
    { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
  },
}

M.config = function()
  require('which-key').setup(M.opts)
end

return M
