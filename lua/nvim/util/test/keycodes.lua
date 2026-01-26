local keys = {
  ' ',
  '	',
  '',
  '<M-CR>',
  '<leader>',
}

local run = function(fn, label)
  vim.tbl_map(function(key)
    local res = fn(key)
    print(label .. ': ' .. key .. ',' .. tostring(res))
  end, keys)
end

-- Turn the internal byte representation of keys into a form that can be used for |:map|
run(vim.fn.keytrans, 'vim.fn.keytrans')

-- vim.api.nvim_replace_termcodes(str, from_part, do_lt, special)
-- vim.keycode =  vim.api.nvim_replace_termcodes(str, true, true, true)
run(vim.keycode, 'vim.keycode')

-- snacks
-- keycode is also just vim.api.nvim_replace_termcodes(str, true, true, true)
run(Snacks.util.keycode, 'Snacks.util.keycode')

-- pretty print
run(Snacks.util.normkey, 'Snacks.util.normkey')
