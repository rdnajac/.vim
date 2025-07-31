nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>
nnoremap <leader>va <Cmd>call edit#vimrc('+/autocmds')<CR>
nnoremap <leader>vc <Cmd>call edit#vimrc('+/commands')<CR>
nnoremap <leader>vk <Cmd>call edit#vimrc('+/keymaps')<CR>
nnoremap <leader>vp <Cmd>call edit#vimrc('+/plugins')<CR>
nnoremap <leader>vs <Cmd>call edit#vimrc('+/settings')<CR>
nnoremap <leader>vu <Cmd>call edit#vimrc('+/ui')<CR>

nnoremap <BSlash>i <Cmd>call edit#module('nvim/init')<CR>
nnoremap <BSlash>m <Cmd>call edit#module('munchies/init')<CR>
nnoremap <BSlash>p <Cmd>call edit#module('plugins/init')<CR>

nnoremap <BSlash>0 <Cmd>call edit#readme()<CR>
