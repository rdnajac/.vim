Snacks.util.set_hl({
  Inactive = { fg = '#aaaaaa' },
  Starting = { fg = '#757755' },
  ServerReady = { fg = '#117711' },
  TCPStart = { fg = '#ff8833' },
  TCPReady = { fg = '#3388ff' },
  RStarting = { fg = '#ff8833' },
  Ready = { fg = '#3388ff' },
}, { prefix = 'RStatus', default = true })

local rstt = {
  { '-', 'RStatusInactive' }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
  { 'S', 'RStatusStarting' }, -- 2: nclientserver started, but not ready yet.
  { 'S', 'RStatusServerReady' }, -- 3: nclientserver is ready.
  { 'S', 'RStatusTCPStart' }, -- 4: nclientserver started the TCP server
  { 'S', 'RStatusTCPReady' }, -- 5: TCP server is ready
  { 'R', 'RStatusRStarting' }, -- 6: R started, but nvimcom was not loaded yet.
  { '󰟔 ', 'RStatusReady' }, -- 7: nvimcom is loaded.
}

_G.Rstatus = {
  function() return rstt[vim.g.R_Nvim_status][1] end,
  color = function() return rstt[vim.g.R_Nvim_status][2] end,
  cond = function() return vim.tbl_contains({ 'r', 'rmd', 'quarto' }, vim.bo.filetype) end,
}
