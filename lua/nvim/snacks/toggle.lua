Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.words():map('<leader>uW')
Snacks.toggle.zoom():map('<leader>uZ')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.line_number():map('<leader>ul')
-- Snacks.toggle.inlay_hints():map('<leader>uh') -- XXX: in lsp.lua
-- TODO: toggle copilot
-- FIXME:
-- local munchies_toggle = require('nvim.snacks.toggle')
--
-- munchies_toggle
--   .translucency()
--   :map('<leader>ub', { desc = 'Toggle Translucent Background' })
-- munchies_toggle.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
-- munchies_toggle.color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
-- munchies_toggle.winborder():map('<leader>uW', { desc = 'Toggle Window Border' })
-- munchies_toggle.laststatus():map('<leader>ul', { desc = 'Toggle Laststatus' })
