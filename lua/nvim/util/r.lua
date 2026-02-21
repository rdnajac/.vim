local M = {}

M.status = function()
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

  return {
    function() return rstt[vim.g.R_Nvim_status][1] end,
    color = function() return rstt[vim.g.R_Nvim_status][2] end,
    cond = function()
      if not vim.tbl_contains({ 'r', 'rmd', 'quarto' }, vim.bo.filetype) then
        return false
      end
      return vim.g.R_Nvim_status and vim.g.R_Nvim_status > 0
    end,
  }
end

return M
