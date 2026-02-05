local M = {}

M.leaks = function()
  local counts = vim
    .iter(vim.api.nvim_get_namespaces())
    :map(function(name, ns)
      return vim.iter(vim.api.nvim_list_bufs()):map(function(buf)
        local count = #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
        if count > 0 then
          return { name = name, buf = buf, count = count, ft = vim.bo[buf].ft }
        end
      end)
    end)
    :flatten()
    :totable()

  table.sort(counts, function(a, b) return a.count > b.count end)

  return counts
end

return M
