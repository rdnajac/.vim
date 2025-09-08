-- Import all specs, flatten dependencies
function M.collect_specs(plugin)
  local specs = {}
  local function add_spec(p)
    local s = to_spec(p)
    if not s then
      return
    end
    table.insert(specs, s)
    for _, field in ipairs({ 'specs' }) do
      local list = s[field]
      if type(list) == 'table' then
        for _, f in ipairs(list) do
          add_spec(f)
        end
      end
    end
  end
  add_spec(plugin)
  return specs
end
