local M = {}

M.sep = package.config:sub(1, 1)
M.modname = require('meta.modname').modname
M.source = require('meta.source').source
M.safe_require = require('meta.require').safe
M.lazy_require = require('meta.require').lazy
-- M.module = require('meta.module')

return M
