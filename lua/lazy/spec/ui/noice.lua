return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  ---@class NoiceConfig
  opts = {
    cmdline = {
      enabled = false,
      view = 'cmdline',
      format = {
        cmdline = { pattern = '^:', icon = '', lang = 'vim' },
        filter = { pattern = '^:%s*!', icon = '!', lang = 'bash' },
        help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋖 ' },
        input = { view = 'cmdline_input', icon = '󰥻 ' },
        lua = { pattern = { '^:%s*lua%s+' }, icon = ' ', lang = 'lua' },
        luaprint = { pattern = { '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = 'ℹ️', lang = 'lua' },
        search_down = { kind = 'search', pattern = '^/', icon = '  ', lang = 'regex' },
        search_up = { kind = 'search', pattern = '^%?', icon = '  ', lang = 'regex' },
      },
    },
    messages = {
      enabled = true,
      view = 'notify',
    },
    notify = { enabled = true },
    popupmenu = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
      -- override = {
      --   ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      --   ['vim.lsp.util.stylize_markdown'] = true,
      --   ['cmp.entry.get_documentation'] = true,
      -- },
    },
    routes = {
      -- {
      --   filter = { event = 'msg_show', kind = 'emsg' },
      --   view = 'notify',
      -- },
      {
        filter = { event = 'msg_show' },
        view = 'mini',
      },
    },
    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>sn', '', desc = '+noice'},
    { '<M-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
    { '<leader>snl', function() require('noice').cmd('last') end,    desc = 'Noice Last Message' },
    { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
    { '<leader>sna', function() require('noice').cmd('all') end,     desc = 'Noice All' },
    { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
    -- { '<leader>snt', function() require('noice').cmd('pick') end,    desc = 'Noice Picker (Telescope/FzfLua)' },
    { '<c-f>', function() if not require('noice.lsp').scroll(4)  then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll Forward', mode = {'i', 'n', 's'} },
    { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'} },
  },
  -- config = function(_, opts)
  --   -- HACK: noice shows messages from before it was enabled,
  --   -- but this is not ideal when Lazy is installing plugins,
  --   -- so clear the messages in this case.
  --   if vim.o.filetype == 'lazy' then
  --     vim.cmd([[messages clear]])
  --   end
  --   require('noice').setup(opts)
  -- end,
}
