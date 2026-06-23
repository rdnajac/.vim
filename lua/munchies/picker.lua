---@type snacks.picker.Config
local M = {
  sources = {
    explorer = require('munchies.explorer'),
    highlights = {
      --- enable mini.hipatterns in the preview buffer
      --- @param picker snacks.Picker
      on_show = function(picker)
        if MiniHipatterns then
          MiniHipatterns.enable(picker.preview.win.buf)
        end
      end,
    },
    -- TODO: show vim location in preview
    keymaps = {
      confirm = 'jump',
      --- add a file and pos to items defined in vimscript
      --- @param item snacks.picker.finder.Item
      transform = function(item)
        if not item.file then
          local sid = item.item.sid
          if sid > 0 then
            local info = vim.fn.getscriptinfo({ sid = item.item.sid })
            item.file = info and info[1] and info[1].name
            item.pos = { item.item.lnum, 0 }
            ---@diagnostic disable-next-line: assign-type-mismatch
            item.preview = 'file'
          end
        end
        return item
      end,
    },
    resume = { exclude = 'pickers' }, -- don't try to resume the picker picker
    zoxide = { confirm = 'jump' }, -- edit the directory instead of loading the session
  },
}

M.actions = {
  -- clear = require('munchies.filter').clear,
  -- filter = require('munchies.filter').filter,
  inspect_self = function(self)
    Snacks.debug.inspect(self)
  end,
  inspect_opts = function(self)
    Snacks.debug.inspect(self.opts)
  end,
  sidekick_send = function(...)
    return require('sidekick.cli.picker.snacks').send(...)
  end,
  toggle = function(self)
    local resume = require('snacks.picker.resume')
    resume.add(self)
    local source = self.opts.source
    local state = resume.state[source]
    local opts = {
      source = source == 'files' and 'grep' or 'files',
      cwd = self:cwd(),
      pattern = state.filter.pattern,
      search = state.filter.search,
    }
    self:close()
    local ret = Snacks.picker.pick(opts)
    ret.list:set_selected(state.selected)
    ret.list:update()
    ret.matcher.task:on(
      'done',
      vim.schedule_wrap(function()
        if ret.closed then
          return
        end
        ret.list:view(state.cursor, state.topline)
      end)
    )
  end,
  --- change picker directory using zoxide and resume
  zoxide = function(self)
    local resume = require('snacks.picker.resume')
    self.on_close = function()
      resume.add(self)
      Snacks.picker.zoxide({
        confirm = function(z, item)
          resume.state[self.opts.source].opts.cwd = item.file
          z:close()
        end,
        layout = 'ivy',
        on_close = function()
          resume.resume()
        end,
      })
    end
    self:close()
  end,
}

return M
