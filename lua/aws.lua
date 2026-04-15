local cache = require('nvim.fs.cache')
local util = require('nvim.util')

vim.env.AWS_DEFAULT_OUTPUT = 'json'

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

---@param args string[] s3api subcommand and arguments
---@return table? decoded JSON response (nil if no output)
local function s3api(args)
  local out = util.run(vim.list_extend({ 'aws', 's3api' }, args), true)
  if out and out ~= '' then
    return vim.json.decode(out --[[@as string]])
  end
end

---@class S3Result
---@field Contents table[] array of objects (if any)
---@field RequestCharged any

---@class S3ObjectEntry
---@field ETag string
---@field Key string object key
---@field LastModified string ISO date
---@field Size integer size in bytes
---@field StorageClass string

local M = {}

---@param bucket_or_uri string s3 uri or bucket name
---@param prefix? string prefix (required if first arg is bucket)
---@return S3ObjectEntry[] list of objects in the bucket/prefix
function M.ls(bucket_or_uri, prefix)
  local bucket, pfx = parse_s3(bucket_or_uri, prefix)
  local args = { 'list-objects-v2', '--bucket', bucket, '--prefix', pfx }
  local cachepath = 's3/' .. vim.uri_encode(table.concat(args, '/'), 'rfc2396') .. '.json'
  local result = cache(cachepath, function() return s3api(args) end) --[[@as table]]
  return result.Contents
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
