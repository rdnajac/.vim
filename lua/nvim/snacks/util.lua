local M = {}

---@module "snacks"
-- see: Snacks.picker.picker_actions()

---@param picker snacks.Picker
M.toggle = function(picker)
  local cwd = picker:cwd()
  local alt = picker.opts.source == 'files' and 'grep' or 'files'
  picker:close()
  if alt == 'files' then
    Snacks.picker.files({ cwd = cwd })
  else
    Snacks.picker.grep({ cwd = cwd })
  end
end

-- M.gen_toggle  = function()
--   return M.toggle
-- end
-- ---@type table<string, snacks.picker.Config>
-- local reopen_state = {}
--
-- ---@param picker snacks.Picker
-- ---@param source string
-- ---@param opts? snacks.picker.Config
-- local reopen_picker = function(picker, source, opts)
--   local on_close = picker.opts.on_close
--   picker.opts.on_close = function(picker) ---@diagnostic disable-line
--     if not picker.skip_reset then
--       reopen_state = {}
--     end
--     if type(on_close) == 'function' then
--       on_close(picker)
--     end
--   end
--   local from_source = picker.opts.source
--   if from_source then
--     reopen_state[from_source] = picker.opts
--     reopen_state[from_source].pattern = picker:filter().pattern
--     reopen_state[from_source].search = picker:filter().search
--   end
--   picker.skip_reset = true
--   picker:close()
--   Snacks.picker.pick(source, vim.tbl_extend('force', reopen_state[source] or {}, opts or {}))
-- end
--
-- return {
--   'folke/snacks.nvim',
--   ---@type snacks.Config
--   opts = {
--     picker = {
--       sources = {
--         files = {
--           actions = {
--             switch_grep = function(picker)
--               reopen_picker(picker, 'grep', { search = picker:filter().pattern })
--             end,
--           },
--           win = {
--             input = {
--               keys = {
--                 ['<M-g>'] = { 'switch_grep', mode = { 'i', 'n' } },
--               },
--             },
--           },
--         },
--         grep = {
--           actions = {
--             switch_files = function(picker)
--               reopen_picker(picker, 'files', { pattern = picker:filter().search })
--             end,
--           },
--           win = {
--             input = {
--               keys = {
--                 ['<M-g>'] = { 'switch_files', mode = { 'i', 'n' } },
--               },
--             },
--           },
--         },
--       },
--     },
--   },
-- }
--
return M
