local M = {}

local function verify_results(funcs)
  local first_result
  local first_name
  for name, fn in pairs(funcs) do
    local result = fn()
    if vim.islist(result) then
      table.sort(result)
    end
    if not first_result then
      first_result = result
      first_name = name
    else
      assert(
        vim.deep_equal(first_result, result),
        string.format('%s returned different result than %s', name, first_name)
      )
    end
  end
end

function M.run(funcs, opts, verify)
  opts = opts or {}
  opts.flush = opts.flush or true
  opts.counts = opts.counts or nil

  if verify ~= false then
    verify_results(funcs)
  end

  local order = vim.tbl_keys(funcs)
  for i = #order, 2, -1 do
    local j = math.random(i)
    order[i], order[j] = order[j], order[i]
  end
  for _, title in ipairs(order) do
    opts.title = title
    Snacks.debug.profile(funcs[title], opts)
  end
end

return M
