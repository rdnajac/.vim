echohl Question
echo "Quit vim? (y/n)"
echohl None
let l:answer = nr2char(getchar())
if l:answer ==? 'y'
  qa
endif
