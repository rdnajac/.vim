local inputs = {
  ':Make',
  ': Make',
  '<Cmd>Make<CR>',
  '<CMD>Make<CR>',
  '<Cmd>!make<CR>',
  ':!make',
  ': ! make',
  ':!make install',
  '!make install',
  'make install',
  '<Cmd>!cargo build<CR>',
  "<Cmd>lua require'mod'.x()<CR>",
  ":lua print('hi')",
  ':<Cmd>Make<CR>',
  ':! ./configure && make',
  '<CMD>!./build.sh<CR>',
  '   ',
  nil,
}

---@param build string
local function parse_build_cmd(build)
  if type(build) ~= 'string' then
    return {}, false
  end

  local raw = vim.trim(build)
  if raw == '' then
    return {}, false
  end

  -- Split by whitespace early
  local tokens = vim.split(raw, '%s+', { trimempty = true })
  if #tokens == 0 then
    return {}, false
  end
  return tokens
end

vim.tbl_map(function(s)
  print(parse_build_cmd(s))
end, inputs)

-- local first = tokens[1]
-- local is_vim_cmd = false
--
-- -- Detect <Cmd> or <CMD>
-- if first:match("^<%s*[Cc][Mm][Dd]%s*>") then
--   is_vim_cmd = not first:match("^<%s*[Cc][Mm][Dd]%s*>%s*!")
--
-- -- Detect colon-prefixed command
-- elseif first:match("^:") then
--   is_vim_cmd = not first:match("^:!?")
-- end
--
-- -- Normalize leading/trailing wrappers
-- for i, token in ipairs(tokens) do
--   token = token
--     :gsub("^<%s*[Cc][Mm][Dd]%s*>", "")
--     :gsub("<%s*[Cc][Rr]%s*>$", "")
--     :gsub("^[:!]+", "")
--   tokens[i] = vim.trim(token)
-- end
--
-- -- Remove empties
-- local cleaned = vim.tbl_filter(function(x) return x ~= "" end, tokens)
--
-- return cleaned, is_vim_cmd

--     if vim.is_callable(self.build) then
--       local ok, result = pcall(self.build(path))
--       notify_build(ok, not ok and result or nil)
--     elseif nv.is_nonempty_string(self.build) then
--       local build_str = self.build
--       -- Ex command (e.g. ":Make", "<Cmd>make<CR>")
--       if build_str:match('^:') or build_str:match('^<Cmd>') then
--         build_str = build_str:gsub('^:', '')
--         build_str = build_str:gsub('^<Cmd>', '')
--         build_str = build_str:gsub('<CR>$', '')
--         local ok, err = pcall(vim.cmd, build_str)
--         notify_build(ok, not ok and err or nil)
--       else
--         -- Normalize leading "!" for shell commands
--         build_str = build_str:gsub('^!', '')
--         local cmd = string.format('cd %s && %s', vim.fn.shellescape(data.spec.dir), build_str)
--         local output = vim.fn.system(cmd)
--         notify_build(vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
--       end
--     else
--       notify_build(false, 'Invalid build type: ' .. type(self.build))
