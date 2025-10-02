-- bench_globpath.lua

math.randomseed(os.time())

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for _ = 1, 1000 do
    fn()
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

local benches = {
  {
    label = "globpath stdpath/config + '/after/lsp'",
    fn = function()
      return vim.fn.globpath(vim.fn.stdpath('config') .. '/after/lsp', '*', true, true)
    end,
  },
  {
    label = "globpath stdpath/config + '/after/lsp/*'",
    fn = function()
      return vim.fn.globpath(vim.fn.stdpath('config'), '/after/lsp/*', true, true)
    end,
  },
  {
    label = 'globpath literal ~/.config/nvim/after/lsp',
    fn = function()
      return vim.fn.globpath('~/.config/nvim/after/lsp', '*', true, true)
    end,
  },
}

for _, b in ipairs(benches) do
  bench(b.label, b.fn)
end
