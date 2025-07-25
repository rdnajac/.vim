if exists(v:servername)
  let $SERVERNAMEFROMNVIM = v:servername
endif
finish

lua <<< EOF
if vim.env.NVIM then
  local ok, chan = pcall(vim.fn.sockconnect, 'pipe', vim.env.NVIM, {rpc=true})
  if ok and chan then
    local client = vim.api.nvim_get_chan_info(chan).client
    local rv = vim.rpcrequest(chan, 'nvim_exec_lua', [[return ... + 1]], { 41 })
    vim.print(('got "%s" from parent Nvim'):format(rv))
    end
    end
    EOF
