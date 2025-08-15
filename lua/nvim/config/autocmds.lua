local aug = vim.api.nvim_create_augroup('nvim_autocmds', { clear = true })

-- Nvim will always call a Lua function with a single table containing information
-- about the triggered autocommand. The most useful keys are
-- • `match`: a string that matched the `pattern` (see |<amatch>|)
-- • `buf`:   the number of the buffer the event was triggered in (see |<abuf>|)
-- • `file`:  the file name of the buffer the event was triggered in (see |<afile>|)
-- • `data`:  a table with other relevant data that is passed for some events

-- TODO: maybe use on buftypes or readonly instead of filetypes 
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'help', 'man', 'qf', 'nvim-pack' },
--   group = aug,
--   callback = function()
--     if Snacks.util.is_transparent() then
--       Snacks.util.wo(0, { winhighlight = Snacks.util.winhl('Normal:SpecialWindow') })
--     end
--   end,
