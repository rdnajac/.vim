" echom 'hi'
" echom globpath('.', '*', false, true)

let luaroot = stdpath('config') . '/lua'
echom readdir(luaroot . '/nvim')
" let g:files = globpath(s:luaroot, 'nvim/*/init.lua', 0, 1)
