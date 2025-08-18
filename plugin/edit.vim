" shortcut!
nnoremap <leader>vv <Cmd>call edit#vimrc()<CR>
nnoremap <leader>va <Cmd>call edit#vimrc('+/Section:\ autocmds')<CR>
nnoremap <leader>vk <Cmd>call edit#vimrc('+/Section:\ keymaps')<CR>
nnoremap <leader>vp <Cmd>call edit#vimrc('+/Section:\ plugins')<CR>
nnoremap <leader>vs <Cmd>call edit#vimrc('+/Section:\ settings')<CR>

nnoremap <BSlash>i <Cmd>call edit#(stdpath('config') . '/init.lua')<CR>
nnoremap <BSlash>m <Cmd>call edit#luamod('nvim/snacks/init')<CR>
nnoremap <BSlash>p <Cmd>call edit#luamod('plug/init')<CR>

nnoremap <BSlash>0 <Cmd>call edit#readme()<CR>

nnoremap <leader>ft <Cmd>call edit#filetype()<CR>
nnoremap <leader>fT <Cmd>call edit#filetype('/after/ftplugin/', '.lua')<CR>
nnoremap <leader>fs <Cmd>call edit#filetype('snippets/', '.json')<CR>
