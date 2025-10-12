-- https://github.com/folke/lazy.nvim/blob/main/lua/lazy/core/handler/event.lua
local M = {
  lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
}
local Event = require('lazy.core.handler.event')
Event.mappings.LazyFile = { id = 'LazyFile', event = M.lazy_file_events }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile

return M
