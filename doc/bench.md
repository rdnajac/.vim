# lua profiling and benchmarking

## file discovery

Getting a list of files from a known directory

### vim.fn

`globpath()`

```lua
 local files = vim.fn.globpath(vim.o.runtimepath, pattern, true, true)
```

### vim.fs

### vim.uv
