-- FIXME: this sucks
M.root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if path == '' then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path

  local best
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.root_dir and path:find(client.root_dir, 1, true) == 1 then
      if not best or #client.root_dir > #best then
        best = client.root_dir
      end
    end
  end
  if best then
    return best
  end

  local markers = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local m = client.config and client.config.root_markers
    if m then
      vim.list_extend(markers, m)
    end
  end
  if #markers > 0 then
    return vim.fs.root(path, markers)
  end
  return vim.fs.root(path, { '.git' })
end
