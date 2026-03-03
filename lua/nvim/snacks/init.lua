return {
  specs = {
    {
      'folke/snacks.nvim',
      opts = {
        bigfile = require('nvim.snacks.bigfile'),
        dashboard = require('nvim.snacks.dashboard'),
        explorer = { replace_netrw = true },
        image = { enabled = true },
        indent = { indent = { only_current = false, only_scope = true } },
        input = { enabled = true },
        -- notifier = require('nvim.snacks.notifier'),
        quickfile = { enabled = true },
        picker = require('nvim.snacks.picker'),
        -- terminal = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        -- statuscolumn = require('nvim.snacks.statuscolumn'),
        -- styles = { notification_history = { height = 0.9, width = 0.9, wo = { wrap = false } } },
        toggle = { which_key = false },
        words = { enabled = true },
      },
      keys = {
        { 'dI', 'dai', { desc = 'Delete (Snacks) Indent', remap = true } },
        { 'vI', 'vai', { desc = 'Select (Snacks) Indent', remap = true } },
        { ']]', function() Snacks.words.jump(vim.v.count1) end, mode = { 'n', 't' } },
        { '[[', function() Snacks.words.jump(-vim.v.count1) end, mode = { 'n', 't' } },
      },
      ---@type table<string, string|snacks.toggle.Opts>
      toggles = {
        ['<leader>ac'] = 'autochdir',
        ['<leader>dpp'] = 'profiler',
        ['<leader>dph'] = 'profiler_highlights',
        ['<leader>ua'] = 'animate',
        ['<leader>ud'] = 'diagnostics',
        ['<leader>uD'] = 'dim',
        ['<leader>ug'] = 'indent',
        ['<leader>uh'] = 'inlay_hints',
        ['<leader>ul'] = 'line_number',
        ['<leader>uS'] = 'scroll',
        ['<leader>ut'] = 'treesitter',
        ['<leader>uW'] = 'words',
        ['<leader>uZ'] = 'zoom',
        ['<leader>us'] = 'spell',
        ['<leader>uL'] = 'relativenumber',
        ['<leader>uw'] = 'wrap',
        ['<leader>uv'] = {
          name = 'Virtual Text',
          get = function() return vim.diagnostic.config().virtual_text ~= false end,
          set = function(state) vim.diagnostic.config({ virtual_text = state }) end,
        },
        ['<leader>ub'] = {
          name = 'Translucency',
          get = function() return Snacks.util.is_transparent() end,
          set = function(state)
            local bg = Snacks.util.color('Normal', 'bg') or '#24283B'
            Snacks.util.set_hl({ Normal = { bg = state and 'none' or bg } })
            vim.api.nvim_exec_autocmds('ColorScheme', { modeline = false })
          end,
        },
        ['<leader>uu'] = {
          name = 'LastStatus',
          get = function() return vim.o.laststatus > 0 end,
          set = function(state)
            if not state then
              vim.w.lastlaststatus = vim.o.laststatus
              vim.o.laststatus = 0
            else
              vim.o.laststatus = vim.w.lastlaststatus or 2
            end
          end,
        },
        ['<leader>u\\'] = {
          name = 'ColorColumn',
          get = function()
            ---@diagnostic disable-next-line: undefined-field
            local cc = vim.opt_local.colorcolumn:get()
            local tw = vim.bo.textwidth
            local col = tostring(tw ~= 0 and tw or 81)
            return vim.tbl_contains(cc, col)
          end,
          set = function(state)
            local tw = vim.bo.textwidth
            local col = tostring(tw ~= 0 and tw or 81)
            vim.opt_local.colorcolumn = state and col or ''
          end,
        },
      },
    },
  },
  after = function()
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = 'snacks_picker_preview',
      callback = function(ev) MiniHipatterns.enable(ev.buf) end,
    })
  end,
}
