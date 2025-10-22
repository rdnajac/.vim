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
    require('which-key').add(nv.plug.get_keys())
    local registers = '*+"-:.%/#=_0123456789qZ'
    require('which-key.plugins.registers').registers = registers
  end,
  keys = {
    -- debug
    { '<leader>d', group = 'debug', icon = { icon = ' ' } },

    -- nnoremap <leader>db <Cmd>Blink status<CR>
    { '<leader>db', '<Cmd>Blink status<CR>', desc = 'Blink Status' },
    -- nnoremap <leader>dc <Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>
    {
      '<leader>dc',
      '<Cmd>=vim.lsp.get_clients()[1].server_capabilities<CR>',
      desc = 'LSP Capabilities',
    },
    -- nnoremap <leader>dd <Cmd>LazyDev debug<CR>
    { '<leader>dd', '<Cmd>LazyDev debug<CR>', desc = 'LazyDev Debug' },
    -- nnoremap <leader>dl <Cmd>LazyDev lsp<CR>
    { '<leader>dl', '<Cmd>LazyDev lsp<CR>', desc = 'LazyDev LSP' },
    -- nnoremap <leader>dL <Cmd>=require('lualine').get_config()<CR>
    { '<leader>dL', '<Cmd>=require("lualine").get_config()<CR>', desc = 'Lualine Config' },
    -- nnoremap <leader>dh <Cmd>packloadall<Bar>checkhealth<CR>
    { '<leader>dh', '<Cmd>packloadall<Bar>checkhealth<CR>', desc = 'Check Health' },
    -- nnoremap <leader>dS <Cmd>=require('snacks').meta.get()<CR>
    { '<leader>dS', '<Cmd>=require("snacks").meta.get()<CR>', desc = 'Snacks Meta' },
    -- nnoremap <leader>dw <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
    {
      '<leader>dw',
      '<Cmd>=vim.lsp.buf.list_workspace_folders()<CR>',
      desc = 'LSP Workspace Folders',
    },
    -- nnoremap <leader>dP <Cmd>=vim.tbl_keys(package.loaded)<CR>
    { '<leader>dP', '<Cmd>=vim.tbl_keys(package.loaded)<CR>', desc = 'Loaded Packages' },
    -- nnoremap <leader>dR <Cmd>=require('r.config').get_config()<CR>
    { '<leader>dR', '<Cmd>=require("r.config").get_config()<CR>', desc = 'R Config' },
    --
  },
}
