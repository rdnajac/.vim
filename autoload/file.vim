let s:filescache = []
function! file#find(arg, _)
  if empty(s:filescache)
    let s:filescache = globpath(git#root(), '**', 1, 1)
	  \ ->filter({_, v -> !isdirectory(v)})
	  \ ->map({_, v -> fnamemodify(v, ':.')}) " `https://github.com/Vimjas/vint/issues/380`
  endif
  return a:arg == '' ? s:filescache : matchfuzzy(s:filescache, a:arg)
endfunction
autocmd CmdlineEnter : let s:filescache = []
