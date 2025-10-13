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
        mode = { 'n', 'v' },
        -- TODO: add each bracket mapping manually
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'z', group = 'fold' },
      },
      {
        mode = { 'n' },
        { 'co', group = 'comment below' },
        { 'cO', group = 'comment above' },
        { '<localleader>l', group = 'vimtex' },
        { '<localleader>r', group = 'R', icon = { icon = ' ', color = 'blue' } },

        -- descriptions
        { 'gx', desc = 'Open with system app' },
        { 'ga', mode = 'x', desc = 'Align' },
        { 'gA', mode = 'x', desc = 'Align (preview)' },
      },
      { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
    },
  },
  after = function()
    -- HACK: global keys
    require('which-key').add(vim.tbl_map(nv.get, vim.tbl_values(nv.keys)))
    local registers = '*+"-:.%/#=_0123456789'
    require('which-key.plugins.registers').registers = registers
  end,
}
