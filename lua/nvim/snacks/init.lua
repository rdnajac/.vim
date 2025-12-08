local M = {
  'folke/snacks.nvim',
  -- dir = vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'),
  ---@type snacks.Config
  opts = {
    bigfile = {
      ---@param ctx { buf: number, ft: string }
      setup = function(ctx)
        vim.b.completion = false
        vim.b.minihipatterns_disable = true
        if vim.fn.exists(':NoMatchParen') == 2 then
          vim.cmd.NoMatchParen()
        end
        vim.cmd.setlocal('foldmethod=manual', 'statuscolumn=', 'conceallevel=0')
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            -- for json files, keep the filetype as json
            -- for other files, set the syntax to the detected ft
            local opt = ctx.ft == 'json' and 'filetype' or 'syntax'
            vim.bo[ctx.buf][opt] = ctx.ft
          end
        end)
      end,
    },
    dashboard = require('nvim.snacks.dashboard'),
    explorer = { replace_netrw = false },
    image = { enabled = true },
    indent = { indent = { only_current = true, only_scope = true } },
    input = { enabled = true },
    notifier = { enabled = false },
    -- notifier = require('nvim.snacks.notifier'),
    quickfile = { enabled = true },
    scratch = { template = 'local x = \n\nprint(x)' },
    terminal = { enabled = true },
    scope = {
      keys = {
        textobject = {
          ii = { min_size = 2, edge = false, cursor = false, desc = 'inner scope' },
          ai = { min_size = 2, cursor = false, desc = 'full scope' },
          -- ag = { min_size = 1, edge = false, cursor = false, treesitter = { enabled = false }, desc = "buffer" },
        },
        jump = {
          ['[i'] = { min_size = 1, bottom = false, cursor = false, edge = true },
          [']i'] = { min_size = 1, bottom = true, cursor = false, edge = true },
        },
      },
    },
    scroll = { enabled = true },
    -- statuscolumn = { enabled = false },
    statuscolumn = {
      left = { 'mark', 'sign' },
      -- left = { 'mark' },
      -- left = {},
      right = { 'fold' },
      folds = { open = true, git_hl = true },
    },
    picker = require('nvim.snacks.picker'),
    styles = {
      lazygit = { height = 0, width = 0 },
      terminal = { wo = { winhighlight = 'Normal:Character' } },
    },
    words = { enabled = true },
  },
  keys = function()
    return require('nvim.snacks.keys')
  end,
  after = function()
    Snacks.picker.scriptnames = function()
      require('nvim.snacks.picker.scriptnames')
    end

    -- assumes input is [a-z],_
    local function to_camel_case(str)
      return str
        :gsub('_(%a)', function(c)
          return c:upper()
        end)
        :gsub('^%l', string.upper)
    end

    -- local pickers
    --
    -- Snacks.picker.pickers({
    --   enter = false,
    --   live = false,
    --   show_empty = true,
    --   on_show = function(p)
    --     return p:close()
    --   end,
    --   on_close = function(p)
    --     pickers = vim.tbl_map(function(m)
    --       return m.text
    --     end, p:items())
    --   end,
    -- })
    local cmds = {}

    vim
      .iter(vim.tbl_keys(Snacks.picker))
      :filter(function(name)
        return not vim.list_contains({
          'config',
          'get',
          'highlight',
          'keymap',
          'lazy',
          'meta',
          'setup',
          'select',
          'util',
        }, name)
      end)
      :each(function(name)
        local cmd = to_camel_case(name)
        cmds[#cmds + 1] = cmd
        -- currently, this only guards against `:Man`
        if vim.fn.exists(':' .. cmd) ~= 2 then
          vim.api.nvim_create_user_command(cmd, function(args)
            local opts = {}
            if nv.fn.is_nonempty_string(args.args) then
              ---@diagnostic disable-next-line: param-type-mismatch
              local ok, result = pcall(loadstring('return {' .. args.args .. '}'))
              if ok and type(result) == 'table' then
                opts = result
              end
            end
            Snacks.picker[name](opts)
          end, { nargs = '?', desc = 'Snacks Picker: ' .. cmd })
        end
      end)
  end,
}

-- stylua: ignore start
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function(...) Snacks.debug.backtrace(...) end
_G.p  = function(...) Snacks.debug.profile(...) end
-- stylua: ignore end
return M
