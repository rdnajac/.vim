function! VimRun(...) range abort
  " If a visual range was given, use that, else use whole buffer
  let l:start = a:firstline
  let l:end   = a:lastline

  " Get lines in range
  let l:lines = getline(l:start, l:end)

  " Build a list of results by evaluating each line
  let l:results = []
  for l:line in l:lines
    if !empty(l:line)
      try
	call add(l:results, eval(l:line))
      catch
	call add(l:results, v:exception)
      endtry
    endif
  endfor

  " Pretty-print the list after the last line in the range
  execute l:end . 'PP' l:results
endfunction

command! -range=% VimRun <line1>,<line2>call VimRun()
