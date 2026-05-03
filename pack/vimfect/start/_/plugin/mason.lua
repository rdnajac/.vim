vim.schedule(function() Plug({ 'mason-org/mason.nvim', opts = {} }) end)

-- TODO: implement one-time install func to hook into packinstall event
-- once = function() vim.cmd.MasonInstall(nv.util.tools()) end,
local tools = {
  'actionlint', -- code action linter
  'mmdc', -- mermaid diagrams
  'tree-sitter-cli',
}

-- TODO: find other tools in lsp dir
local function other_tools()
  local ret = {}
  ret[#ret + 1] = 'stylua'
  return ret
end
-- TODO: add formatters

tools = vim.list_extend(tools, other_tools())
