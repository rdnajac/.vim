---@module "snacks"

local M = {
  ---@type snacks.picker.debug
  debug = {
    -- scores = true,
    -- leaks = true,
    -- explorer = true,
    -- files = true,
    -- grep = true,
    -- proc = true,
    -- extmarks = true,
  },
  layouts = {
    mylayout = require('munchies.picker.layout'),
    -- pop-up for selecting text in insert mode
    insert = {
      layout = {
        reverse = true,
        relative = 'cursor',
        row = 1,
        width = 0.3,
        min_width = 48,
        height = 0.3,
        border = 'none',
        box = 'vertical',
        { win = 'input', height = 1, border = 'rounded', wo = { cursorline = false } },
        { win = 'list', border = 'rounded' },
      },
    },
  },
  sources = {
    -- autocmds = { confirm =  },
    buffers = {
      layout = 'mylayout',
      input = { keys = { ['<C-x>'] = { 'bufdelete', mode = { 'n', 'i' } } } },
    },
    explorer = require('nvim.fs.explorer'),
    -- files = require('nvim.picker.config'),
    -- grep = require('nvim.picker.config'),
    -- git_status = { layout = 'left' },
    keymaps = {
      ---@param p snacks.Picker
      ---@param item snacks.picker.Item
      confirm = function(p, item)
        if item.file and item.file ~= '' then
          local info = vim.fn.getscriptinfo({ sid = item.item.sid })
          item.file = info and info[1] and info[1].name
          item.pos = { item.item.lnum, 0 }
        end
        p:action({ 'jump' })
      end,
    },
    -- help = { layout = 'ivy' },
    icons = { layout = 'insert' },
    recent = { config = function(p) p.filter = {} end },
    zoxide = { confirm = 'edit' },
    -- mine!
    cheatsheets = {
      finder = 'files',
      cwd = vim.fn.stdpath('config') .. '/doc',
      layout = { preset = 'insert' },
      confirm = function(p, item)
        p:close()
        Snacks.zen({ win = { file = item._path } })
      end,
    },
    -- TODO: where is it??
    -- todo = require('nvim.util.todo').snacks_picker_opts,
  },
}

-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   pattern = 'snacks_picker_preview',
--   callback = function(ev)
--     if MiniHipatterns then
--       MiniHipatterns.enable(ev.buf)
--     end
--   end,
-- })

return M
