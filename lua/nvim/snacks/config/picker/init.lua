---@module "snacks"
---@type snacks.picker.Config
return {
  debug = {
    -- scores = true, -- show scores in the list
    -- leaks = true, -- show when pickers don't get garbage collected
    -- explorer = true, -- show explorer debug info
    -- files = true, -- show file debug info
    -- grep = true, -- show file debug info
    -- proc = true, -- show proc debug info
    -- extmarks = true, -- show extmarks errors
  },
  layout = { preset = 'mylayout' },
  layouts = { mylayout = require('nvim.snacks.config.picker.layout') },
  sources = {
    buffers = {
      input = {
        keys = {
          ['<c-x>'] = { 'bufdelete', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['D'] = 'bufdelete' } },
    },
    explorer = require('nvim.snacks.config.explorer'),
    files = require('nvim.snacks.config.picker.util').opts_extend,
    grep = require('nvim.snacks.config.picker.util').opts_extend,
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
    zoxide = { confirm = 'edit' },
    -- scripts = {
    --   title = 'Scriptnames',
    --   items = function()
    --     local items = {}
    --     -- Use vim.schedule or vim.defer_fn to defer execution
    --     -- Return empty items for now; they will update later asynchronously if possible
    --     -- FIXME:
    --     vim.schedule(function()
    --       local ok, result = pcall(vim.api.nvim_exec2, 'scriptnames', { output = true })
    --       if not ok then
    --         print('Error running scriptnames:', result)
    --         return
    --       else
    --         print('Successfully retrieved scriptnames.')
    --         dd(result.output)
    --       end
    --       for _, line in ipairs(vim.split(result.output, '\n', { plain = true, trimempty = true })) do
    --         local idx, path = line:match('^%s*(%d+):%s+(.*)$')
    --         if idx and path then
    --           table.insert(items, {
    --             formatted = path,
    --             text = string.format('%3d %s', idx, path),
    --             file = path,
    --             item = path,
    --             idx = tonumber(idx),
    --           })
    --         end
    --       end
    --     end)
    --
    --     return items
    --   end,
    --   format = function(item)
    --     return { { item.text } }
    --   end,
    --   sort = { fields = { 'idx' } },
    -- },
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
  win = require('nvim.snacks.config.picker.win'),
}
