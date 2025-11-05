# lua profiling and benchmarking

## getting a list of files from a known directory

### `globpath()`



M.globpath = function()
  return vim.fn.globpath(vim.o.runtimepath, pattern, true, true)
end


