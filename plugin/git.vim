nnoremap gb vi'"zy:!open https://github.com/<C-R>z<CR>
xnoremap gb    "zy:!open https://github.com/<C-R>z<CR>

nnoremap <leader>gN <Cmd>execute '!open' git#repo('neovim/neovim')<CR>
nnoremap <leader>gZ <Cmd>execute '!open' git#repo('lazyvim/lazyvim')<CR>
" TODO: handle cancelled input
nnoremap <leader>gx <Cmd>execute '!open' git#repo(input('GitHub repo (user/repo): '))<CR>

if exists('g:loaded_fugitive')
  nnoremap <leader>ga <Cmd>Gwrite<CR>
  nnoremap gcd <Cmd>Gcd<Bar>pwd<CR>
else
  nnoremap <leader>ga <Cmd>!git add %<CR>
  nnoremap gcd <Cmd>exe 'cd' git#root()<Bar>pwd<CR>
endif

" MiniDiff
" - `vip` followed by `gh` / `gH` applies/resets same as `ghip` / `gHip`
" - `gh_` / `gH_` applies/resets current line
" - `ghgh` / `gHgh` applies/resets hunk range under cursor
" - `dgh` deletes hunk range under cursor
" - `[H` / `[h` / `]h` / `]H` navigate hungs

nnoremap <leader>gb <Cmd>lua Snacks.picker.git_branches()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gL <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>
