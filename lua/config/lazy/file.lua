-- HACK: add support for the LazyFile event
local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }
local Event = require('lazy.core.handler.event')

Event.mappings.LazyFile = { id = 'LazyFile', event = lazy_file_events }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile
