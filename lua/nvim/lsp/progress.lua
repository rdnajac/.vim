vim.schedule(function()
  local ns = vim.api.nvim_create_namespace('lsp_progress')
  local timer = assert(vim.uv.new_timer())
  local buf = -1
  local win = -1
  ---@param msg string|string[]
  ---@param hl? string
  ---@param keep_ms? integer
  local notify = function(msg, hl, keep_ms)
    ---@cast msg string[]
    msg = type(msg) == 'string' and vim.split(msg, '\n') or msg
    hl = hl or 'Normal'
    local vpad = 0
    local hpad = 0
    local min_width = 10
    local max_width = vim.iter(msg):fold(min_width, function(acc, v)
      return math.max(acc, #v)
    end)
    local win_config = { ---@type vim.api.keyset.win_config
      relative = 'editor',
      anchor = 'SE',
      row = vim.o.lines - 2,
      col = vim.o.columns,
      width = max_width + hpad * 2,
      height = #msg + vpad * 2,
      zindex = 1000,
      style = 'minimal',
      border = 'single',
    }
    if not vim.api.nvim_buf_is_valid(buf) then
      buf = vim.api.nvim_create_buf(false, true)
    end
    if not vim.api.nvim_win_is_valid(win) then
      win = vim.api.nvim_open_win(buf, false, win_config)
    else
      vim.api.nvim_win_set_config(win, win_config)
    end
    local hp = string.rep(' ', hpad)
    local vp = vim.fn['repeat']({ hp }, vpad)
    local lines = {}
    vim.list_extend(lines, vp)
    -- stylua: ignore
    vim.list_extend(lines, vim.tbl_map(function(line) return hp .. line .. hp end, msg))
    vim.list_extend(lines, vp)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.hl.range(buf, ns, hl, { 0, 0 }, { #lines, -1 })
    if keep_ms and keep_ms > 1 then
      timer:start(keep_ms, 0, function()
        timer:stop()
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end)
      end)
    end
    return win ---@type integer
  end
  -- Setup
  vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('lsp_progress', { clear = true }),
    callback = function(e)
      local client = assert(vim.lsp.get_client_by_id(e.data.client_id))
      local value = e.data.params.value
      local create_msg = function(progress)
        -- return string.format('[%s] %s %d%%', client.name, value.title, progress)
        return string.format('%s: %s [%s, %02d%%]', client.name, value.title, value.message, progress)
      end
      if value.kind == 'end' then
        notify(create_msg(100), 'Special', 1000)
      else
        notify(create_msg(value.percentage), 'Conceal', 5000)
      end
    end,
  })
end)
