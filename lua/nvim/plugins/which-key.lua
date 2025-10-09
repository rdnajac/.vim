return {
  'folke/which-key.nvim',
  --- @class wk.Opts
  opts = {
    keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
    preset = 'helix',
    show_help = false,
    sort = { 'order', 'alphanum', 'case', 'mod' },
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
        { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },

        -- descriptions
        { 'gx', desc = 'Open with system app' },
      },
      { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
    },
  },
  after = function()
    local registers = '*+"-:.%/#=_0123456789'
    require('which-key.plugins.registers').registers = registers
  end,
}
