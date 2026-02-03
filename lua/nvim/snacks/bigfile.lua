return {
  ---@param ctx {buf:number, ft:string}
  setup = function(ctx)
    vim.b.completion = false
    vim.b.minihipatterns_disable = true
    if vim.fn.exists(':NoMatchParen') == 2 then
      vim.cmd.NoMatchParen()
    end
    vim.cmd.setlocal('foldmethod=manual', 'statuscolumn=', 'conceallevel=0')
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        -- for json files, keep the filetype as json
        -- for other files, set the syntax to the detected ft
        local opt = ctx.ft == 'json' and 'filetype' or 'syntax'
        vim.bo[ctx.buf][opt] = ctx.ft
      end
    end)
  end,
}
