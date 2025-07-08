function! s:test_git_relative() abort
  let tests = [
  \ ['~/projects/myrepo/', '~/projects/myrepo/src/main.c'],
  \ ['/usr/include/', '/usr/include/stdio.h'],
  \ ['~/projects/otherrepo/', '~/projects/otherrepo/README.md'],
  \ ['~/', '~/unrelated/file.txt'],
  \ ]

  for [base, file] in tests
    let base = expand(base)
    let file = expand(file)
    let [root, rel] = GitRelative(base, file)
    echom 'Base: ' . base
    echom 'File: ' . file
    echom 'Git root: ' . root
    echom 'Relative: ' . rel
    echom '---'
  endfor
endfunction

command! TestGitRelative call s:test_git_relative()
