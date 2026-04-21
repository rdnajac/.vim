local cache = nv.fs.cache

---@param args string[] s3api subcommand and arguments
---@param opts? table?
---@return table? decoded JSON response (nil if no output)
local function s3api(args, opts)
  local rv = vim
    .system(
      vim.list_extend({ 'aws', 's3api' }, args),
      vim.tbl_deep_extend('force', {
        text = true,
        env = { AWS_DEFAULT_OUTPUT = 'json' },
      }, opts or {})
    )
    :wait()
  if rv.code == 0 then
    return vim.json.decode(rv.stdout)
  end
  if rv.stdout and #rv.stdout > 0 then
    print(rv.stdout)
  end
  if rv.stderr and #rv.stderr > 0 then
    print(rv.stderr)
  end
end

---@class S3Result
---@field Contents table[] array of objects (if any)
---@field RequestCharged any

---@class S3Object
---@field ETag string
---@field Key string object key
---@field LastModified string ISO date
---@field Size integer size in bytes
---@field StorageClass string

local M = {}

function M.ls(bucket) return s3api({ 'list-objects-v2', '--bucket', bucket }) end

---@param bucket_or_uri string s3 uri (s3://bucket/prefix) or bucket name
---@param prefix? string required if first arg is bucket name
---@return string bucket
---@return string prefix
local function parse_s3(bucket_or_uri, prefix)
  if prefix then
    return bucket_or_uri, prefix
  end
  local b, p = bucket_or_uri:match('^s3://([^/]+)/(.*)$')
  if not b then
    error('Invalid s3 uri: ' .. bucket_or_uri)
  end
  return b, p
end

---@param bucket_or_uri string s3 uri or bucket name
---@param prefix? string prefix (required if first arg is bucket)
---@return string[] list of s3 uris
function M.files(bucket_or_uri, prefix)
  local bucket, pfx = parse_s3(bucket_or_uri, prefix)
  local contents = M.ls(bucket, pfx)
  return vim.tbl_map(function(entry) return ('s3://%s/%s'):format(bucket, entry.Key) end, contents)
end

---Restore (thaw) a Glacier object
---@param bucket_or_uri string s3 uri or bucket name
---@param key? string object key (required if first arg is bucket)
---@param days? integer number of days to keep restored copy (default 7)
---@param tier? string retrieval tier: 'Expedited'|'Standard'|'Bulk' (default 'Standard')
function M.restore(bucket_or_uri, key, days, tier)
  local bucket
  bucket, key = parse_s3(bucket_or_uri, key)
  days = days or 7
  tier = tier or 'Standard'
  local restore_request = ('{"Days":%d,"GlacierJobParameters":{"Tier":"%s"}}'):format(days, tier)
  s3api({
    'restore-object',
    '--bucket',
    bucket,
    '--key',
    key,
    '--restore-request',
    restore_request,
  })
end

---Restore all DEEP_ARCHIVE objects in a bucket/prefix
---@param bucket_or_uri string s3 uri or bucket name
---@param prefix? string prefix (required if first arg is bucket)
---@param days? integer number of days to keep restored copy (default 7)
---@param tier? string retrieval tier: 'Expedited'|'Standard'|'Bulk' (default 'Standard')
---@return string[] list of restored keys
function M.restore_bucket(bucket_or_uri, prefix, days, tier)
  local bucket, pfx = parse_s3(bucket_or_uri, prefix)
  local objects = M.ls(bucket, pfx)
  return vim
    .iter(objects)
    :filter(function(f) return f.StorageClass == 'DEEP_ARCHIVE' end)
    :map(function(f)
      print(('Restoring %s'):format(f.Key))
      M.restore(bucket, f.Key, days, tier)
      return f.Key
    end)
    :totable()
end

return M
