local plug_home = vim.g.plug_home or '/Users/rdn/.local/share/nvim/site/pack/core/opt'
local snacks = plug_home .. '/snacks.nvim'
vim.opt.rtp:append(snacks)

---@type snacks.profiler.Config
local opts = {
  thresholds = {
    time = { 1, 10 },
    pct = { 1, 20 },
    count = { 1, 100 },
    ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
    presets = {
      startup = { min_time = 0.1, sort = false },
      on_stop = {},
      filter_by_plugin = function()
        return { filter = { def_plugin = vim.fn.input('Filter by plugin: ') } }
      end,
    },
  },
}

return require('snacks.profiler').startup(opts)
