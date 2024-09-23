augroup formatters
  autocmd!
  
  " use shellfmt and shellharden to format shell scripts
  autocmd FileType sh setlocal formatprg=shellharden\ --transform\ <(shfmt\ -bn\ -sr\ -ci\ -kp\ %)
  " -i,  --indent uint       0 for tabs (default), >0 for number of spaces
  " -bn, --binary-next-line  binary ops like && and | may start a line
  " -sr, --space-redirects   redirect operators will be followed by a space
  " -fn, --func-next-line    function opening braces are placed on a separate line
  
  autocmd FileType python setlocal formatprg=black\ --quiet\ -
  autocmd FileType markdown,html,css,json,scss,js,jsx,ts,tsx setlocal formatprg=prettier\ --stdin-filepath\ %

augroup END
