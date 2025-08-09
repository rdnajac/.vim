---@module "snacks"
---@type snacks.picker.Config
return {
  layout = { preset = 'ivy' },
  layouts = {
    ---@type snacks.picker.layout.Config
    mylayout = {
      reverse = true,
      layout = {
        box = 'vertical',
        backdrop = false,
        height = 0.4,
        row = vim.o.lines - math.floor(0.4 * vim.o.lines),
        { win = 'list', border = 'rounded', title_pos = 'left' },
        { win = 'input', height = 1 },
      },
      { win = 'input', height = 1 },
    },
  },
  -- sources = require('nvim.snacks.config.pickers'),
  -- win = require('nvim.snacks.config.win'),
  ---@class snacks.picker.debug
  debug = {
    scores = false, -- show scores in the list
    leaks = true, -- show when pickers don't get garbage collected
    explorer = true, -- show explorer debug info
    files = true, -- show file debug info
    grep = true, -- show file debug info
    proc = true, -- show proc debug info
    extmarks = false, -- show extmarks errors
  },
  ---@type snacks.picker.sources.Config|{}|table<string, snacks.picker.Config|{}>
  sources = {
    explorer = require('nvim.snacks.config.explorer'),
    files = {
      config = function(opts)
        opts.cwd = opts.cwd or vim.fn.getcwd()
        ---@diagnostic disable-next-line: param-type-mismatch
        opts.title = ' Find [ ' .. vim.fn.fnamemodify(opts.cwd, ':~') .. ' ]'
        return opts
      end,
      -- matcher = { frecency = true },
      actions = {
        toggle = function(self)
          require('nvim.snacks.util').toggle(self)
        end,
      },
    },
    grep = {
      cwd = vim.fn.getcwd(),
      config = function(opts)
        opts.cwd = opts.cwd or vim.fn.getcwd()
        opts.title = '󰱽 Grep (' .. picker.fn.fnamemodify(opts.cwd, ':~') .. ')'
        return opts
      end,
      actions = {
        toggle = function(self)
          require('nvim.snacks.util').toggle(self)
        end,
      },
    },
    icons = {
      layout = {
        layout = {
          reverse = true,
          relative = 'cursor',
          row = 1,
          width = 0.3,
          min_width = 48,
          height = 0.3,
          border = 'none',
          box = 'vertical',
          { win = 'input', height = 1, border = 'rounded' },
          { win = 'list', border = 'rounded' },
        },
      },
    },
    zoxide = {
      confirm = 'edit',
    },
    -- mine
    scripts = {
      title = 'Scriptnames',
      items = function()
        local items = {}
        -- Use vim.schedule or vim.defer_fn to defer execution
        -- Return empty items for now; they will update later asynchronously if possible
        -- FIXME:
        vim.schedule(function()
          local ok, result = pcall(vim.api.nvim_exec2, 'scriptnames', { output = true })
          if not ok then
            print('Error running scriptnames:', result)
            return
          else
            print('Successfully retrieved scriptnames.')
            dd(result.output)
          end
          for _, line in ipairs(vim.split(result.output, '\n', { plain = true, trimempty = true })) do
            local idx, path = line:match('^%s*(%d+):%s+(.*)$')
            if idx and path then
              table.insert(items, {
                formatted = path,
                text = string.format('%3d %s', idx, path),
                file = path,
                item = path,
                idx = tonumber(idx),
              })
            end
          end
        end)

        return items
      end,
      format = function(item)
        return { { item.text } }
      end,
      sort = { fields = { 'idx' } },
    },
    -- subdir = {
    --   title = 'Select directory',
    --   items = function()
    --     local result = {}
    --     for name, type in vim.fs.dir(dir) do
    --       if type == 'directory' then
    --         table.insert(result, {
    --           text = name,
    --           file = vim.fs.joinpath(dir, name),
    --         })
    --       end
    --     end
    --     return result
    --   end,
    --   format = function(entry)
    --     return { { entry.text } }
    --   end,
    --   -- confirm = function(self, entry)
    --   --   if self.opts.on_select then
    --   --     self.opts.on_select(entry.file)
    --   --   end
    --   -- end,
    -- },
  },
  ---@type snacks.picker.win.Config
  win = {
    preview = { minimal = true },
    input = {
      keys = {
        ['<Esc>'] = { 'close', mode = { 'n' } },
        ['<C-J>'] = { 'toggle', mode = { 'n', 'i' }, desc = 'Toggle Files/Grep' },
        -- change dir with zoxide and continue picking
        ['<m-z>'] = {
          function(picker, item)
            picker.close()
            picker.cd(item.file)
            Snacks.picker.zoxide({
              confirm = function(_, item)
                -- vim.cmd.cd(vim.fn.fnameescape(item.file))
                Snacks.picker.resume({ cwd = item.file })
              end,
            })
            -- Snacks.picker.actions.cd(_, item)
            -- Snacks.picker.actions.lcd(_, item)
          end,
          mode = { 'i', 'n' },
        },
        -- ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
        -- ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
        -- ['<C-c>'] = { 'cancel', mode = 'i' },
        -- ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
        -- ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
        -- ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
        -- ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
        -- ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
        -- ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
        -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
        -- ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
        -- ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
        -- ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
        -- ['<c-f>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
        -- ['<c-g>'] = { 'toggle_live', mode = { 'i', 'n' } },
        -- ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
        -- ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
        -- ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
        -- ['<c-s>'] = { 'edit_split', mode = { 'i', 'n' } },
        -- ['<c-t>'] = { 'tab', mode = { 'n', 'i' } },
        -- ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
        -- ['<c-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
        -- remove insert mode keymaps that conflict with vim-rsi
        -- <M-d> Delete forwards one word.
        ['<a-d>'] = { 'inspect', mode = { 'n' } },
        -- <M-f> Go forwards one word.
        ['<a-f>'] = { 'toggle_follow', mode = { 'n' } },
        -- <C-a> Go to beginning of line.
        ['<c-a>'] = { 'select_all', mode = { 'n' } },
        -- <C-b> Go backwards one character.  On a blank line, kill it
        ['<c-b>'] = { 'preview_scroll_up', mode = { 'n' } },
        -- <C-d> Delete character in front of cursor.  Falls back to
        ['<c-d>'] = { 'list_scroll_down', mode = { 'n' } },
      },
    },
  },
}
