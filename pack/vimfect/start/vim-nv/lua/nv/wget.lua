--- Download a URL either to a file or return as a string.
---
--- @param url string The URL for the request.
--- @param opts? table Optional parameters:
---   - `verbose`     (boolean|nil): Enables verbose output.
---   - `retry`       (integer|nil): Number of retries on transient failures.
---   - `outpath`     (string|nil): File path to save the response body to. If set, the `body` value
---                                  in the Response Object will be `true` instead of the response body.
---   - `headers`     (table<string,string>|nil): Optional request headers.
---   - `force`       (boolean|nil): Overwrite existing file (default: false).
---   - `create_dirs` (boolean|nil): Create directories for `outpath` (default: true).
---   - `callback`    (fun(err?: string, response?: { body: string|boolean })|nil): Callback invoked on completion.
local function wget(url, opts)
  opts = opts or {}
  local outpath = opts.outpath
  local force = opts.force or false
  local create_dirs = opts.create_dirs ~= false
  local callback = opts.callback

  local function notify(msg, level)
    if opts.verbose then
      vim.notify(msg, level or vim.log.levels.INFO)
    end
  end

  if outpath and not force and vim.fn.filereadable(outpath) == 1 then
    notify('Skipping download (exists): ' .. outpath)
    if callback then
      callback(nil, { body = true })
    end
    return true
  end

  if outpath and create_dirs then
    vim.fn.mkdir(vim.fn.fnamemodify(outpath, ':h'), 'p')
  end

  local done, result, err
  vim.net.request(url, {
    outpath = outpath,
    retry = opts.retry,
    headers = opts.headers,
    verbose = opts.verbose,
  }, function(e, r)
    err, result = e, r
    done = true
  end)

  local start = vim.loop.now()
  while not done do
    vim.wait(50)
  end

  if err then
    local msg = 'Download failed: ' .. tostring(err)
    notify(msg, vim.log.levels.ERROR)
    if callback then
      callback(msg)
    end
    error(msg)
  end

  if outpath then
    local ok = vim.fn.filereadable(outpath) == 1 and vim.fn.getfsize(outpath) > 0
    if not ok then
      local msg = 'Download incomplete: ' .. outpath
      notify(msg, vim.log.levels.ERROR)
      if callback then
        callback(msg)
      end
      error(msg)
    end
    notify('Downloaded ' .. url .. ' → ' .. outpath)
    if callback then
      callback(nil, { body = true })
    end
    return true
  else
    local body = result and result.body or ''
    if callback then
      callback(nil, { body = body })
    end
    return body
  end
end

return wget
