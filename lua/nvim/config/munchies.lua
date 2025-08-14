local munchies_toggle = require('nvim.snacks.toggle')

munchies_toggle.translucency():map('<leader>ub', { desc = 'Toggle Translucent Background' })
munchies_toggle.virtual_text():map('<leader>uv', { desc = 'Toggle Virtual Text' })
munchies_toggle.color_column():map('<leader>u\\', { desc = 'Toggle Color Column' })
munchies_toggle.winborder():map('<leader>uW', { desc = 'Toggle Window Border' })
munchies_toggle.laststatus():map('<leader>ul', { desc = 'Toggle Laststatus' })
