local M = { 'folke/which-key.nvim' }

M.opts = {
  keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
  preset = 'helix',
  show_help = false,
  sort = { 'order', 'alphanum', 'case', 'mod' },
  -- triggers = { { ',', mode = { 'i' } } },
  -- triggers = { { '<leader>', mode = { 'n', 'v' } }, },
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
      {
        '<leader>b',
        group = 'buffer',
        expand = function()
          return require('which-key.extras').expand.buf()
        end,
      },
      {
        '<c-w>',
        group = 'windows',
        expand = function()
          return require('which-key.extras').expand.win()
        end,
      },

      { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
      {
        icon = { icon = ' ', color = 'green' },
        { '<leader>E' },
        { '<leader>c', group = 'code' },
        { '<leader>i' },
        { '<leader>m' },
        { '<leader>t' },
        { '<leader>v', group = 'vimrc' },
        { '<leader>w' },
        { '<leader>ft', desc = 'filetype plugin' },
        { '<leader>fs', desc = 'filetype snippets' },
      },
      {
        icon = { icon = '󰢱 ', color = 'blue' },
        { '<leader>fT', desc = 'filetype plugin (.lua)' },
      },

      -- groups
      { 'co', group = 'comment below' },
      { 'cO', group = 'comment above' },

      { '<leader>dp', group = 'profiler' },
      { '<localleader>l', group = 'vimtex' },

      -- descriptions
      { 'gx', desc = 'Open with system app' },
    },
    { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
    {
      mode = { 'i' },
      { ',', group = 'completion' },
      { ',o', '<C-x><C-o>', desc = 'Omni completion' },
      { ',f', '<C-x><C-f>', desc = 'File name completion' },
      { ',i', '<C-x><C-i>', desc = 'Keyword completion from current and included files' },
      { ',l', '<C-x><C-l>', desc = 'Line completion' },
      { ',n', '<C-x><C-n>', desc = 'Keyword completion from current file' },
      { ',t', '<C-x><C-]>', desc = 'Tag completion' },
      { ',u', '<C-x><C-u>', desc = 'User-defined completion' },
    },
  },
}

M.config = function()
  require('which-key').setup(M.opts)
end

return M
