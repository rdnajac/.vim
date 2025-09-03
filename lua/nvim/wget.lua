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
  local callback = opts.callback
    or function(err, resp)
      if err then
        vim.notify('wget error: ' .. err, vim.log.levels.ERROR)
      elseif outpath then
        vim.notify('Downloaded ' .. url .. ' → ' .. outpath, vim.log.levels.INFO)
      else
        vim.notify('Downloaded ' .. url, vim.log.levels.INFO)
      end
    end

  -- Skip if file exists and not forcing
  if outpath and not opts.force and vim.fn.filereadable(outpath) == 1 then
    callback(nil, { body = true })
    return
  end

  -- Ensure directories if writing to disk
  if outpath and opts.create_dirs ~= false then
    vim.fn.mkdir(vim.fn.fnamemodify(outpath, ':h'), 'p')
  end

  -- Pass supported options directly to vim.net.request
  local request_opts = {
    outpath = outpath,
    retry = opts.retry,
    headers = opts.headers,
    verbose = opts.verbose,
  }

  vim.net.request(
    url,
    request_opts,
    vim.schedule_wrap(function(err, resp)
      if err then
        callback('Failed to fetch ' .. url .. ': ' .. tostring(err))
        return
      end

      if outpath then
        callback(nil, { body = true }) -- written to disk
      else
        callback(nil, { body = resp and resp.body or '' })
      end
    end)
  )
end

return wget
