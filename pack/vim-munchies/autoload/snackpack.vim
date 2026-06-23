" from `tani/vim-jetpack`
if exists('g:loaded_jetpack')
  finish
endif
let g:loaded_jetpack = 1

if has('nvim')
  function! jetpack#execute(code) abort
    return v:lua.vim.cmd(a:code)
  endfunction
else
  function! jetpack#execute(code) abort
    let c = bufnr()
    let t = bufadd('')
    execute 'silent buffer' t
    call setline(1, split(a:code, "\n"))
    source
    execute 'silent bwipeout!' t
    execute 'silent buffer' c
  endfunction
endif

let g:jetpack_njobs = get(g:, 'jetpack_njobs', 8)
let g:jetpack_download_method = get(g:, 'jetpack_download_method', has('ivim') ? 'curl' : 'git')

let s:cmds = {}
let s:maps = {}
let s:declared_packages = {}
let s:status = {
\   'pending': 'pending',
\   'skipped': 'skipped',
\   'installed': 'installed',
\   'installing': 'installing',
\   'updated': 'updated',
\   'updating': 'updating',
\   'switched': 'switched',
\   'copied': 'copied'
\ }

function! jetpack#make_progressbar(n) abort
  return '[' . join(map(range(0, 100, 3), {_, v -> v < a:n ? '=' : ' '}), '') . ']'
endfunction

function! jetpack#jobstatus(job) abort
  if has('nvim')
    return jobwait([a:job], 0)[0] == -1 ? 'run' : 'dead'
  endif
  return job_status(a:job)
endfunction

function! jetpack#jobcount(jobs) abort
  return len(filter(copy(a:jobs), { _, val -> jetpack#jobstatus(val) ==# 'run' }))
endfunction

function! jetpack#jobwait(jobs, njobs) abort
  let running = jetpack#jobcount(a:jobs)
  while running > a:njobs
    let running = jetpack#jobcount(a:jobs)
  endwhile
endfunction

" Original: https://github.com/lambdalisue/vital-Whisky/blob/90c71/autoload/vital/__vital__/System/Job/Vim.vim#L46
"  License: https://github.com/lambdalisue/vital-Whisky/blob/90c71/LICENSE
function! jetpack#nvim_exit_cb(cmd, buf, cb, job, st) abort
  let ch = job_getchannel(a:job)
  while ch_status(ch) ==# 'open' | sleep 1ms | endwhile
  while ch_status(ch) ==# 'buffered' | sleep 1ms | endwhile
  if a:st != 0
    echoerr '`'.join(a:cmd, ' ').'`:'.join(a:buf, "\n")
  endif
  call a:cb(join(a:buf, "\n"))
endfunction

if has('nvim')
  function! jetpack#jobstart(cmd, cb) abort
    let buf = []
    return jobstart(a:cmd, {
    \   'on_stdout': { _, data -> extend(buf, data) },
    \   'on_stderr': { _, data -> extend(buf, data) },
    \   'on_exit': { _, st -> st != 0 ? execute("echoerr '`'.join(a:cmd, ' ').'`:'.join(buf, '')") : a:cb(join(buf, '')) }
    \ })
  endfunction

  function! jetpack#system(cmd) abort
    return a:cmd->split(" ")->system()
  endfunction
else
  function! jetpack#jobstart(cmd, cb) abort
    let buf = []
    return job_start(a:cmd, {
    \   'out_mode': 'raw',
    \   'out_cb': { _, data -> extend(buf, split(data, "\n")) },
    \   'err_mode': 'raw',
    \   'err_cb': { _, data -> extend(buf, split(data, "\n")) },
    \   'exit_cb': function('jetpack#nvim_exit_cb', [a:cmd, buf, a:cb])
    \ })
  endfunction

  function! jetpack#system(cmd) abort
    let buf = []
    let job = job_start(a:cmd, {
          \ 'out_cb': { _, data -> extend(buf, split(data, "\n")) }
          \})
    call jetpack#jobwait([job], 0)
    return buf->join("\n")
  endfunction
endif

function! jetpack#initialize_buffer() abort
  execute 'silent! bdelete!' bufnr('JetpackStatus')
  silent 40vnew +setlocal\ buftype=nofile\ nobuflisted\ nonumber\ norelativenumber\ signcolumn=no\ noswapfile\ nowrap JetpackStatus
  syntax clear
  syntax match jetpackProgress /^[a-z]*ing/
  syntax match jetpackComplete /^[a-z]*ed/
  syntax keyword jetpackSkipped ^skipped
  highlight def link jetpackProgress DiffChange
  highlight def link jetpackComplete DiffAdd
  highlight def link jetpackSkipped DiffDelete
  redraw
endfunction

function! jetpack#show_progress(title) abort
  let buf = bufnr('JetpackStatus')
  call deletebufline(buf, 1, '$')
  let processed = len(filter(copy(s:declared_packages), { _, val -> val.status[-1] =~# 'ed' }))
  call setbufline(buf, 1, printf('%s (%d / %d)', a:title, processed, len(s:declared_packages)))
  call appendbufline(buf, '$', jetpack#make_progressbar((0.0 + processed) / len(s:declared_packages) * 100))
  for [pkg_name, pkg] in items(s:declared_packages)
    call appendbufline(buf, '$', printf('%s %s', pkg.status[-1], pkg_name))
  endfor
  redraw
endfunction

function! jetpack#show_result() abort
  let buf = bufnr('JetpackStatus')
  call deletebufline(buf, 1, '$')
  call setbufline(buf, 1, 'Result')
  call appendbufline(buf, '$', jetpack#make_progressbar(100))
  for [pkg_name, pkg] in items(s:declared_packages)
    if index(pkg.status, s:status.installed) >= 0
      call appendbufline(buf, '$', printf('installed %s', pkg_name))
    elseif index(pkg.status, s:status.updated) >= 0
      call appendbufline(buf, '$', printf('updated %s', pkg_name))
    else
      call appendbufline(buf, '$', printf('skipped %s', pkg_name))
    endif
    let output = substitute(pkg.output, '\r\n\|\r', '\n', 'g')
    let output = substitute(output, '^From.\{-}\zs\n\s*', '/compare/', '')
    for line in split(output, '\n')
      call appendbufline(buf, '$', printf('  %s', line))
    endfor
  endfor
  redraw
endfunction

function! jetpack#postupdate_plugins() abort
  for [pkg_name, pkg] in items(s:declared_packages)
    if empty(pkg.do) || pkg.output =~# 'Already up to date.'
      continue
    endif
    call jetpack#load(pkg_name)
    let pwd = chdir(pkg.path)
    if type(pkg.do) == v:t_func
      call pkg.do()
    elseif type(pkg.do) == v:t_string
      if pkg.do =~# '^:'
	execute pkg.do
      else
	call jetpack#system(pkg.do)
      endif
    endif
    call chdir(pwd)
  endfor
  for dir in glob(s:optdir . '/*/doc', '', 1)
    execute 'silent! helptags' dir
  endfor
  call mkdir(s:optdir . '/_/plugin', 'p')
  call mkdir(s:optdir . '/_/after/plugin', 'p')
  call writefile([
	\ 'autocmd Jetpack User JetpackPre:init ++once :',
	\ 'doautocmd <nomodeline> User JetpackPre:init'
	\ ], s:optdir . '/_/plugin/hook.vim')
  call writefile([
	\ 'autocmd Jetpack User JetpackPost:init ++once :',
	\ 'doautocmd <nomodeline> User JetpackPost:init'
	\ ], s:optdir . '/_/after/plugin/hook.vim')
endfunction

function! jetpack#sync() abort
  call jetpack#initialize_buffer()
  call jetpack#show_result()
  let s:available_packages = deepcopy(s:declared_packages)
  for pkg in values(s:available_packages) | unlet pkg.do | endfor
  call writefile([json_encode(s:available_packages)], s:optdir . '/available_packages.json')
  call jetpack#postupdate_plugins()
  if has('nvim') && !empty(luaeval('vim.loader'))
    lua vim.loader.reset()
  endif
endfunction

function! jetpack#is_local_plug(repo) abort
  return a:repo[0] =~# '[/$~]'
endfunction

function! jetpack#is_opt(pkg) abort
  return !empty(a:pkg.dependers_before)
	\ || !empty(a:pkg.dependers_after)
	\ || !empty(a:pkg.cmd)
	\ || !empty(a:pkg.keys)
	\ || !empty(a:pkg.event)
endfunction

function! jetpack#gets(pkg, keys, default) abort
  let values = []
  for key in a:keys
    if has_key(a:pkg, key)
      if type(a:pkg[key]) == v:t_list
	call extend(values, a:pkg[key])
      else
	call add(values, a:pkg[key])
      endif
    endif
  endfor
  return empty(values) ? a:default : values
endfunction

function! jetpack#add(plugin, ...) abort
  let opts = a:0 > 0 ? a:1 : {}
  let name = jetpack#gets(opts, ['as', 'name'], [fnamemodify(a:plugin, ':t')])[0]
  if has_key(s:declared_packages, name)
    return
  endif
  let local = jetpack#is_local_plug(a:plugin)
  let url = local ? expand(a:plugin) : (a:plugin !~# '.\+://' ? 'https://github.com/' : '') . a:plugin
  let path = s:optdir . '/' .  substitute(url, '.\+/\(.\+\)', '\1', '')
  let path = expand(local ? a:plugin : jetpack#gets(opts, ['dir', 'path'], [path])[0])
  let dependees = jetpack#gets(opts, ['requires', 'depends'], [])
  call map(dependees, { _, r -> r =~# '/' ? substitute(r, '.*/', '', '') : r })
  let dependers_before = jetpack#gets(opts, ['before', 'on_source'], [])
  call map(dependers_before, { _, r -> r =~# '/' ? substitute(r, '.*/', '', '') : r })
  let dependers_after = jetpack#gets(opts, ['after', 'on_post_source'], [])
  call map(dependers_after, { _, r -> r =~# '/' ? substitute(r, '.*/', '', '') : r })
  let keys_on = jetpack#gets(opts, ['on'], [])
  call filter(keys_on, { _, k -> k =~? '^<Plug>' })
  let keys = keys_on + jetpack#gets(opts, ['keys', 'on_map'], [])
  let cmd_on = jetpack#gets(opts, ['on'], [])
  call filter(cmd_on, { _, k -> k =~? '^[A-Z]' })
  let cmd = cmd_on + jetpack#gets(opts, ['cmd', 'on_cmd'], [])
  let event = jetpack#gets(opts, ['on', 'event', 'on_event'], [])
  call filter(event, { _, v -> exists('##' . substitute(v, ' .*', '', ''))})
  let filetypes = jetpack#gets(opts, ['for', 'ft', 'on_ft'], [])
  call extend(event, map(filetypes, {_, ft -> 'FileType ' . ft}))
  let pkg  = {
	\   'keys': keys,
	\   'cmd': cmd,
	\   'event': event,
	\   'url': url,
	\   'local': local,
	\   'branch': get(opts, 'branch', ''),
	\   'tag': get(opts, 'tag', ''),
	\   'commit': get(opts, 'commit', 'HEAD'),
	\   'rtp': get(opts, 'rtp', ''),
	\   'do': jetpack#gets(opts, ['do', 'run', 'build'], [''])[0],
	\   'frozen': jetpack#gets(opts, ['frozen', 'lock'], [v:false])[0],
	\   'dir': jetpack#gets(opts, ['dir', 'path'], [''])[0],
	\   'path': path,
	\   'status': [s:status.pending],
	\   'output': '',
	\   'hook_add': get(opts, 'hook_add', ''),
	\   'hook_source': get(opts, 'hook_source', ''),
	\   'hook_post_source': get(opts, 'hook_post_source', ''),
	\   'dependees': dependees,
	\   'dependers_before': dependers_before,
	\   'dependers_after': dependers_after,
	\ }
  let pkg.opt = get(opts, 'opt', jetpack#is_opt(pkg))
  let s:declared_packages[name] = pkg
  call jetpack#execute(pkg.hook_add)
endfunction

function! jetpack#begin(...) abort
  " In lua, passing nil and no argument are synonymous, but in practice, v:null is passed.
  if a:0 > 0 && a:1 != v:null
    let s:home = expand(a:1)
    execute 'set runtimepath^=' . expand(s:home)
    execute 'set packpath^=' . expand(s:home)
  elseif has('nvim')
    let s:home = stdpath('data') . '/' . 'site'
  else
    let s:home = expand('~/.vim')
  endif
  let s:cmds = {}
  let s:maps = {}
  let s:declared_packages = {}
  let s:optdir = s:home . '/pack/jetpack/opt'
  let runtimepath = split(&runtimepath, ',')
  let runtimepath = filter(runtimepath, {_, v -> v !~# s:optdir})
  let &runtimepath = join(runtimepath, ',')
  let available_packages_file = s:optdir . '/available_packages.json'
  let available_packages_text =
	\ filereadable(available_packages_file)
	\ ? join(readfile(available_packages_file)) : "{}"
  let s:available_packages = json_decode(available_packages_text)
  augroup Jetpack
    autocmd!
  augroup END
  command! -nargs=+ -bar Jetpack call jetpack#add(<args>)
endfunction

function! jetpack#doautocmd(ord, pkg_name) abort
  let pkg = jetpack#get(a:pkg_name)
  if jetpack#tap(a:pkg_name) || (pkg.local && isdirectory(pkg.path . '/' . pkg.rtp))
    let pattern_a = 'jetpack_' . a:pkg_name . '_' . a:ord
    let pattern_a = substitute(pattern_a, '\W\+', '_', 'g')
    let pattern_a = substitute(pattern_a, '\(^\|_\)\(.\)', '\u\2', 'g')
    let pattern_b = 'Jetpack' . substitute(a:ord, '.*', '\u\0', '') . ':'. a:pkg_name
    for pattern in [pattern_a, pattern_b]
      if exists('#User#' . pattern)
	execute 'doautocmd <nomodeline> User' pattern
      endif
    endfor
  endif
endfunction

function! jetpack#load_plugin(pkg_name) abort
  let pkg = jetpack#get(a:pkg_name)
  for dep_name in pkg.dependees
    call jetpack#load_plugin(dep_name)
  endfor
  let &runtimepath = pkg.path . '/' . pkg.rtp . ',' . &runtimepath
  if v:vim_did_enter
    call jetpack#doautocmd('pre', a:pkg_name)
    for file in glob(pkg.path . '/' . pkg.rtp . '/plugin/**/*.vim', '', 1)
      execute 'source' file
    endfor
    for file in glob(pkg.path . '/' . pkg.rtp . '/plugin/**/*.lua', '', 1)
      execute 'luafile' file
    endfor
  else
    let cmd = 'call jetpack#doautocmd("pre", "'.a:pkg_name.'")'
    execute 'autocmd Jetpack User JetpackPre:init ++once' cmd
  endif
endfunction

function! jetpack#load_after_plugin(pkg_name) abort
  let pkg = jetpack#get(a:pkg_name)
  let &runtimepath = &runtimepath . ',' . pkg.path . '/' . pkg.rtp
  if v:vim_did_enter
    for file in glob(pkg.path . '/' . pkg.rtp . '/after/plugin/**/*.vim', '', 1)
      execute 'source' file
    endfor
    for file in glob(pkg.path . '/' . pkg.rtp . '/after/plugin/**/*.lua', '', 1)
      execute 'luafile' file
    endfor
    call jetpack#doautocmd('post', a:pkg_name)
  else
    let cmd = 'call jetpack#doautocmd("post", "'.a:pkg_name.'")'
    execute 'autocmd Jetpack User JetpackPost:init ++once' cmd
  endif
  for dep_name in pkg.dependees
    call jetpack#load_after_plugin(dep_name)
  endfor
endfunction

function! jetpack#check_dependees(pkg_name) abort
  if !jetpack#tap(a:pkg_name)
    return v:false
  endif
  let pkg = jetpack#get(a:pkg_name)
  for dep_name in pkg.dependees
    if !jetpack#check_dependees(dep_name)
      return v:false
    endif
  endfor
  return v:true
endfunction

function! jetpack#load(pkg_name) abort
  if !jetpack#check_dependees(a:pkg_name)
    return v:false
  endif
  call jetpack#load_plugin(a:pkg_name)
  call jetpack#load_after_plugin(a:pkg_name)
  return v:true
endfunction

" Original: https://github.com/junegunn/vim-plug/blob/e3001/plug.vim#L683-L693
"  License: MIT, https://raw.githubusercontent.com/junegunn/vim-plug/e3001/LICENSE
function! jetpack#load_map(map, names, with_prefix, prefix)
  for name in a:names
    call jetpack#load(name)
  endfor
  let extra = ''
  let code = getchar(0)
  while (code != 0 && code != 27)
    let extra .= nr2char(code)
    let code = getchar(0)
  endwhile
  if a:with_prefix
    let prefix = v:count ? v:count : ''
    let prefix .= '"'.v:register.a:prefix
    if mode(1) ==# 'no'
      if v:operator ==# 'c'
	let prefix = "\<Esc>" . prefix
      endif
      let prefix .= v:operator
    endif
    call feedkeys(prefix, 'n')
  endif
  call feedkeys(substitute(a:map, '^<Plug>', "\<Plug>", 'i') . extra)
endfunction

function! jetpack#load_cmd(cmd, names, ...) abort
  execute 'delcommand' a:cmd
  for name in a:names
    call jetpack#load(name)
  endfor
  let args = a:0>0 ? join(a:000, ' ') : ''
  try
    execute a:cmd args
  catch /.*/
    call vim#notify#error(v:exception)
  endtry
endfunction

function! jetpack#end() abort
  let runtimepath = []
  delcommand Jetpack
  command! -bar JetpackSync call jetpack#sync()

  syntax off
  filetype plugin indent off

  if !has_key(s:declared_packages, 'vim-jetpack')
    echomsg 'vim-jetpack is not declared. Please add jetpack#add("tani/vim-jetpack") .'
  endif

  if sort(keys(s:declared_packages)) != sort(keys(s:available_packages))
    echomsg 'Some packages are not synchronized. Run :JetpackSync'
  endif

  for [pkg_name, pkg] in items(s:declared_packages)
    for dep_name in pkg.dependers_before
      let cmd = 'call jetpack#load("'.pkg_name.'")'
      let pattern = 'JetpackPre:'.dep_name
      execute 'autocmd Jetpack User' pattern '++once' cmd
    endfor
    let slug = substitute(pkg_name, '\W\+', '_', 'g')
    let s:loaded_count_{slug} = len(pkg.dependers_after)
    for dep_name in pkg.dependers_after
      let cmd = 'if s:loaded_count_'.slug.' == 1 '.
	    \ '|  call jetpack#load("'.pkg_name.'") '.
	    \ '| else'.
	    \ '|  let s:loaded_count_'.slug.' -= 1 '.
	    \ '| endif'
      let pattern = 'JetpackPost:'.dep_name
      execute 'autocmd Jetpack User' pattern '++once' cmd
    endfor
    for it in pkg.keys
      let s:maps[it] = add(get(s:maps, it, []), pkg_name)
      execute printf('inoremap <silent> %s <C-\><C-O>:<C-U>call jetpack#load_map("%s", %s, 0, "")<CR>', it, it, s:maps[it])
      execute printf('nnoremap <silent> %s :<C-U>call jetpack#load_map("%s", %s, 1, "")<CR>', it, it, s:maps[it])
      execute printf('vnoremap <silent> %s :<C-U>call jetpack#load_map("%s", %s, 1, "gv")<CR>', it, it, s:maps[it])
      execute printf('onoremap <silent> %s :<C-U>call jetpack#load_map("%s", %s, 1, "")<CR>', it, it, s:maps[it])
    endfor
    for it in pkg.event
      let cmd = 'call jetpack#load("'.pkg_name.'")'
      let [event, pattern] = split(it . (it =~# ' ' ? '' : ' *'), ' ')
      execute 'autocmd Jetpack' event pattern '++once' cmd
    endfor
    for it in pkg.cmd
      let cmd_name = substitute(it, '^:', '', '')
      let s:cmds[cmd_name] = add(get(s:cmds, cmd_name, []), pkg_name)
      let cmd = printf('call jetpack#load_cmd("%s", %s, <f-args>)', cmd_name, s:cmds[cmd_name])
      execute 'command! -range -nargs=*' cmd_name ':' cmd
    endfor
    if !empty(pkg.hook_source)
      let pattern = 'JetpackPre:'.pkg_name
      let cmd = 'call jetpack#execute(s:declared_packages["'.pkg_name.'"].hook_source)'
      execute 'autocmd Jetpack User' pattern '++once' cmd
    endif
    if !empty(pkg.hook_post_source)
      let pattern = 'JetpackPost:'.pkg_name
      let cmd = 'call jetpack#execute(s:declared_packages["'.pkg_name.'"].hook_post_source)'
      execute 'autocmd Jetpack User' pattern '++once' cmd
    endif
    if pkg.opt
      for file in glob(pkg.path . '/ftdetect/*.vim', '', 1)
	"echomsg '[[source' file ']]'
	execute 'source' file
      endfor
      for file in glob(pkg.path . '/ftdetect/*.lua', '', 1)
	"echomsg '[[luafile' file ']]'
	execute 'luafile' file
      endfor
    else
      let runtimepath = extend([pkg.path . '/' . pkg.rtp], runtimepath)
      let runtimepath = extend(runtimepath, [pkg.path . '/' . pkg.rtp . '/after'])
      let cmd = 'call jetpack#doautocmd("pre", "'.pkg_name.'")'
      execute 'autocmd Jetpack User JetpackPre:init ++once' cmd
      let cmd = 'call jetpack#doautocmd("post", "'.pkg_name.'")'
      execute 'autocmd Jetpack User JetpackPost:init ++once' cmd
    endif
  endfor
  let runtimepath = extend([s:optdir . '/_'], runtimepath)
  let runtimepath = extend(runtimepath, [s:optdir . '/_/after'])
  let &runtimepath .= ',' . join(runtimepath, ',')
  syntax enable
  filetype plugin indent on
  if has('nvim') && !empty(luaeval('vim.loader'))
    lua vim.loader.enable()
  endif
endfunction

function! jetpack#tap(name) abort
  return has_key(s:available_packages, a:name) && has_key(s:declared_packages, a:name)
endfunction

function! jetpack#names() abort
  return keys(s:declared_packages)
endfunction

function! jetpack#get(name) abort
  return get(s:declared_packages, a:name, {})
endfunction
