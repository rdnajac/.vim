" plugin/surround.vim
nmap S viWS
xmap ` S`
xmap F Sf

" toggle 'single' or "double" quotes
nmap cq <Cmd>call vim#with#savedView("normal cs\"'")<CR>
nmap cQ <Cmd>call vim#with#savedView("normal cs'\"")<CR>

nmap sc sr
if !has('nvim')
  nmap sa ys
  nmap sd ds
  nmap sr cs
else
  nmap ys sa
  nmap ds sd
  nmap cs sr
  nmap yss ys_
  xmap <silent> S :<C-u>lua MiniSurround.add('visual')<CR>
  " lua vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
  lua << EOF
  local opts = {
    -- mappings = {
      --   add = 'ys',
      --   delete = 'ds',
      --   find = '',
      --   find_left = '',
      --   highlight = '',
      --   replace = 'cs',
      --   -- Add this only if you don't want to use extended mappings
      --   suffix_last = '',
      --   suffix_next = '',
      -- },
      -- search_method = 'cover_or_next',
      custom_surroundings = {
	B = { output = { left = '{', right = '}' } },
      },
      }
  vim.schedule(function() require('mini.surround').setup(opts) end)
EOF
endif
