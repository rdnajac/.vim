-- ~/.local/share/nvim/share/nvim/runtime/lua/vim/pack.lua:375
--- @param plug_list vim.pack.Plug[]
--- @param f async fun(p: vim.pack.Plug)
--- @param progress_action string
local function run_list(plug_list, f, progress_action)
  local report_progress = new_progress_report(progress_action)

  -- Construct array of functions to execute in parallel
  local n_finished = 0
  local funs = {} --- @type (async fun())[]
  for _, p in ipairs(plug_list) do
    -- Run only for plugins which didn't error before
    if p.info.err == '' then
      --- @async
      funs[#funs + 1] = function()
        local ok, err = copcall(f, p) --[[@as string]]
        if not ok then
          p.info.err = err --- @as string
        end

        -- Show progress
        n_finished = n_finished + 1
        local percent = math.floor(100 * n_finished / #funs)
        report_progress('report', percent, '(%d/%d) - %s', n_finished, #funs, p.spec.name)
      end
    end
  end

  if #funs == 0 then
    return
  end

  -- Run async in parallel but wait for all to finish/timeout
  report_progress('begin', 0, '(0/%d)', #funs)

  --- @async
  local function joined_f()
    async.join(n_threads, funs)
  end
  async.run(joined_f):wait()

  report_progress('end', 100, '(%d/%d)', #funs, #funs)
end

