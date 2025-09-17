local M = { 'folke/which-key.nvim' }

--- @module "which-key"
---@class wk.Opts
M.opts = {
  keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
  preset = 'helix',
  show_help = false,
  sort = { 'order', 'alphanum', 'case', 'mod' },
  ---@param mapping wk.Mapping
  filter = function(mapping)
    return mapping.desc and mapping.desc ~= ''
    -- return true
  end,
  spec = {
    {
      {
        mode = { 'n', 'v' },
        -- TODO: add each bracket mapping manually
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'z', group = 'fold' },
      },

      mode = { 'n' },
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
  local reg_mod = require('which-key.plugins.registers')
  reg_mod.registers = '*+"-:.%/#=_0123456789'
  require('which-key').setup(M.opts)
end

return M
