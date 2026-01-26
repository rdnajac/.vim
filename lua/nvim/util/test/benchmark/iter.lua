-- test data
local plugs = vim.pack.get()

require('test.benchmark').run({
  iter = function()
    return vim
      .iter(plugs)
      :filter(function(p) return not p.active end)
      :map(function(p) return p.spec.name end)
      :totable()
  end,
  forloop = function()
    local names = {}
    for _, p in ipairs(plugs) do
      if not p.active then
        names[#names + 1] = p.spec.name
      end
    end
    return names
  end,
  tbl_map_and_filter = function()
    local filtered = vim.tbl_filter(function(p) return not p.active end, plugs)
    return vim.tbl_map(function(p) return p.spec.name end, filtered)
  end,
  tbl_map = function()
    return vim.tbl_map(function(p) return p.active and p.spec.name or nil end, plugs)
  end,
})
