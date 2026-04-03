local severity_map = {
  E = vim.diagnostic.severity.ERROR,
  W = vim.diagnostic.severity.WARN,
  I = vim.diagnostic.severity.INFO,
}

return {
  ---Send diagnostics to the Neovim diagnostics API
  ---@param buffer number The buffer number to retreive the variable for.
  ---@param loclist table The loclist array to report as diagnostics.
  ---@return nil
  send = function(buffer, loclist)
    local diagnostics = vim
      .iter(loclist)
      :filter(function(location) return location.bufnr == buffer end)
      :map(
        function(location)
          return {
            lnum = location.lnum - 1,
            end_lnum = (location.end_lnum or location.lnum) - 1,
            col = math.max((location.col or 1) - 1, 0),
            end_col = location.end_col,
            severity = severity_map[location.type] or 'E',
            code = location.code,
            message = location.text,
            source = location.linter_name,
          }
        end
      )
      :totable()
    local ns = vim.api.nvim_create_namespace('ale')
    vim.diagnostic.set(ns, buffer, diagnostics, {})
  end,
}
