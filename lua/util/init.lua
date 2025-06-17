vim.cmd([[
  command! CD lua require('util.cd').changedir()
  command! SmartCD lua require('util.cd').smart_cd()
  command! -bang Quit lua require("util.quit").func('<bang>')
]])
