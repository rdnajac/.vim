--- Sets up the experimental external UI for Neovim if available.
--- This module checks if the 'vim._extui' module can be loaded and, if
--- successful, enables it with default settings.
---
--- from `$VIMRUNTIME/lua/vim/_extui.lua`:
---```lua
---require('vim._extui').enable({
---  enable = true, -- Whether to enable or disable the UI.
---  msg = { -- Options related to the message module.
---    ---@type 'cmd'|'msg' Where to place regular messages, either in the
---    ---cmdline or in a separate ephemeral message window.
---    target = 'cmd',
---    timeout = 4000, -- Time a message is visible in the message window.
---  },
---})
---```
local opts = {}

local ok, extui = pcall(require, 'vim._extui')
if ok and extui then
  extui.enable(opts)
end
